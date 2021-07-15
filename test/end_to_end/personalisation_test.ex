defmodule EndToEnd.PersonalisationTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.Clients.LambdaMock
  alias Fixtures.AuthToken

  @moduletag :end_to_end

  @response %{
    "headers" => %{
      "cache-control" => "private"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  test "non-personalised request" do
    expect_origin_request(fn %{headers: headers} ->
      refute headers[:authorization]
      refute headers[:"x-authentication-provider"]
      refute headers[:"pers-env"]
      refute headers[:"ctx-age-bracket"]
      refute headers[:"ctx-allow-personalisation"]
    end)

    build_request()
    |> make_request()
    |> assert_successful_response()
  end

  test "personalised request" do
    token = AuthToken.valid_access_token()

    expect_origin_request(fn %{headers: headers} ->
      assert headers[:authorization] == "Bearer #{token}"
      assert headers[:"ctx-allow-personalisation"] == "true"
      assert headers[:"x-authentication-provider"]
      assert headers[:"pers-env"]
      assert headers[:"ctx-age-bracket"]
    end)

    response =
      build_request()
      |> personalise_request(token)
      |> make_request()
      |> assert_successful_response()

    [vary_header] = get_resp_header(response, "vary")
    assert vary_header =~ "x-id-oidc-signedin"
  end

  test "invalid auth token" do
    token = AuthToken.invalid_access_token()

    expect_no_origin_request()

    conn =
      build_request()
      |> personalise_request(token)
      |> make_request()

    assert conn.status == 302

    assert {"location",
            "https://session.test.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fmy%2Fsession%2Fwebcore-platform"} in conn.resp_headers
  end

  test "use non-personalised cached response as fallback" do
    request = build_request()

    # Store non-personalised response in cache
    response = Map.put(@response, "headers", %{"cache-control" => "public, max-age=60"})
    stub_origin_request(response: {:ok, response})

    request
    |> make_request()
    |> assert_successful_response()

    # Simulate origin failure
    stub_origin_request(response: {:error, :boom})

    request
    |> personalise_request()
    |> make_request()
    |> assert_successful_response()
  end

  defp expect_origin_request(fun, opts \\ []) do
    expect(LambdaMock, :call, fn _role_arn, _function_arn, request, _request_id, _opts ->
      fun.(request)
      Keyword.get(opts, :response, {:ok, @response})
    end)
  end

  defp expect_no_origin_request() do
    expect(LambdaMock, :call, 0, fn _role_arn, _function_arn, _request, _request_id, _opts -> nil end)
  end

  defp stub_origin_request(opts) do
    expect_origin_request(fn _req -> nil end, opts)
  end

  defp build_request() do
    :get
    |> conn("/my/session/webcore-platform")
    |> Map.put(:host, "www.bbc.co.uk")
  end

  defp personalise_request(conn, token \\ AuthToken.valid_access_token()) do
    conn
    |> put_req_header("cookie", "ckns_atkn=#{token}")
    |> put_req_header("x-id-oidc-signedin", "1")
  end

  defp make_request(conn) do
    Router.call(conn, [])
  end

  defp assert_successful_response(conn) do
    assert conn.status == 200
    assert conn.resp_body == @response["body"]
    conn
  end
end
