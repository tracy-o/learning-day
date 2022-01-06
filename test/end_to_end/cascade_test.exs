defmodule EndToEnd.CascadeTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_cache: 0]
  import Belfrage.Test.PersonalisationHelper

  alias BelfrageWeb.Router
  alias Belfrage.Clients.{LambdaMock, HTTPMock, HTTP}
  alias Plug.Conn
  alias Fixtures.AuthToken

  @cascade_route "/cascade"

  test "first non-404 response from origins in the cascade is used" do
    expect_request_to_origin(:lambda, status: 200, body: "Lambda response")
    expect_no_request_to_origin(:mozart)

    conn = make_request()
    assert conn.status == 200
    assert conn.resp_body == "Lambda response"

    expect_request_to_origin(:lambda, status: 404)
    expect_request_to_origin(:mozart, status: 200, body: "Mozart response")

    conn = make_request()
    assert conn.status == 200
    assert conn.resp_body == "Mozart response"
  end

  test "errors halt the cascade and are used as response" do
    expect_request_to_origin(:lambda, status: 500, body: "Lambda error")
    expect_no_request_to_origin(:mozart)

    conn = make_request()
    assert conn.status == 500
    assert conn.resp_body == "Lambda error"

    expect_request_to_origin(:lambda, status: 404)
    expect_request_to_origin(:mozart, status: 500, body: "Mozart error")

    conn = make_request()
    assert conn.status == 500
    assert conn.resp_body == "Mozart error"
  end

  test "if none of the origins can handle the request, a 404 is returned" do
    expect_request_to_origin(:lambda, status: 404)
    expect_request_to_origin(:mozart, status: 404)

    conn = make_request()
    assert conn.status == 404
  end

  test "origins are not requested when there is a fresh cached response available" do
    # The `q` query parameter will cause different request hashes for requests to
    # Lambda and Mozart and so the corresponding responses will be cached
    # separately. This is because the parameter is only whiltelisted for Mozart.
    route = @cascade_route <> "?q=foo"

    # Populate the cache with a response from Lambda
    expect_request_to_origin(:lambda, status: 200, body: "Cached Lambda response", cache_control: "public, max-age=60")
    assert make_request(route).status == 200

    expect_no_requests_to_origins()

    conn = make_request(route)
    assert conn.status == 200
    assert conn.resp_body == "Cached Lambda response"

    clear_cache()

    # Populate the cache with a response from Mozart
    expect_request_to_origin(:lambda, status: 404)
    expect_request_to_origin(:mozart, status: 200, body: "Cached Mozart response", cache_control: "public, max-age=60")
    assert make_request(route).status == 200

    expect_no_requests_to_origins()

    conn = make_request(route)
    assert conn.status == 200
    assert conn.resp_body == "Cached Mozart response"

    clear_cache()
  end

  test "origins are not requested when request pipeline generates a response" do
    expect_no_requests_to_origins()

    # Add a trailing slash to the request path to trigger a redirect by the
    # `TrailingSlashRedirector` transformer
    conn = make_request(@cascade_route <> "/")
    assert conn.status == 301
  end

  test "stale cached response is used as fallback" do
    # The `q` query parameter will cause different request hashes for requests to
    # Lambda and Mozart and so the corresponding responses will be cached
    # separately. This is because the parameter is only whiltelisted for Mozart.
    route = @cascade_route <> "?q=foo"

    # Populate the cache with a stale response from Lambda
    expect_request_to_origin(:lambda, status: 200, body: "Cached Lambda response", cache_control: "public, max-age=-1")
    assert make_request(route).status == 200

    expect_request_to_origin(:lambda, status: 500)
    expect_no_request_to_origin(:mozart)

    conn = make_request(route)
    assert conn.status == 200
    assert conn.resp_body == "Cached Lambda response"
    assert Conn.get_resp_header(conn, "belfrage-cache-status") == ~w(STALE)

    clear_cache()

    # Populate the cache with a stale response from Mozart
    expect_request_to_origin(:lambda, status: 404)
    expect_request_to_origin(:mozart, status: 200, body: "Cached Mozart response", cache_control: "public, max-age=-1")
    assert make_request(route).status == 200

    expect_request_to_origin(:lambda, status: 404)
    expect_request_to_origin(:mozart, status: 500)

    conn = make_request(route)
    assert conn.status == 200
    assert conn.resp_body == "Cached Mozart response"
    assert Conn.get_resp_header(conn, "belfrage-cache-status") == ~w(STALE)

    clear_cache()
  end

  test "personalisation data is only sent to origins for which personalisation is enabled" do
    token = AuthToken.valid_access_token()

    expect_request_to_origin(:lambda,
      status: 404,
      callback: fn request ->
        assert request.headers[:authorization] == "Bearer #{token}"
      end
    )

    expect_request_to_origin(:mozart,
      status: 200,
      callback: fn request ->
        refute request.headers["authorization"]
      end
    )

    conn =
      build_request()
      |> personalise_request(token)
      |> make_request()

    assert conn.status == 200
  end

  defp expect_request_to_origin(:lambda, opts) do
    expect(LambdaMock, :call, fn _role_arn, _func_arn, payload, _request_id, _opts ->
      if callback = opts[:callback] do
        callback.(payload)
      end

      {:ok,
       %{
         "statusCode" => Keyword.get(opts, :status, 200),
         "headers" => %{
           "cache-control" => Keyword.get(opts, :cache_control, "private")
         },
         "body" => Keyword.get(opts, :body, "Lambda response")
       }}
    end)
  end

  defp expect_request_to_origin(:mozart, opts) do
    expect(HTTPMock, :execute, fn request, _platform ->
      if callback = opts[:callback] do
        callback.(request)
      end

      {:ok,
       %HTTP.Response{
         status_code: Keyword.get(opts, :status, 200),
         headers: %{
           "cache-control" => Keyword.get(opts, :cache_control, "private")
         },
         body: Keyword.get(opts, :body, "Lambda response")
       }}
    end)
  end

  defp expect_no_request_to_origin(:lambda) do
    expect(LambdaMock, :call, 0, fn _role_arn, _func_arn, _payload, _request_id, _opts ->
      flunk("Lambda should not be called")
    end)
  end

  defp expect_no_request_to_origin(:mozart) do
    expect(HTTPMock, :execute, 0, fn _request, _platform ->
      flunk("Mozart should not be called")
    end)
  end

  defp expect_no_requests_to_origins() do
    expect_no_request_to_origin(:lambda)
    expect_no_request_to_origin(:mozart)
  end

  defp build_request(route \\ @cascade_route) do
    :get
    |> conn(route)
    |> Map.put(:host, "www.bbc.co.uk")
  end

  defp make_request(route \\ @cascade_route)

  defp make_request(conn = %Conn{}) do
    Router.call(conn, [])
  end

  defp make_request(route) do
    route
    |> build_request()
    |> make_request()
  end
end
