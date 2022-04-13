defmodule EndToEnd.App.PersonalisationTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.{CachingHelper, PersonalisationHelper}

  alias BelfrageWeb.Router
  alias Belfrage.{Clients.HTTPMock, Clients.HTTP, RouteState}
  alias Fixtures.AuthToken

  @token AuthToken.valid_access_token()

  @moduletag :end_to_end

  setup do
    clear_cache()
    start_supervised!({RouteState, "SomeRouteState"})
    :ok
  end

  @response HTTP.Response.new(%{
              status_code: 200,
              body: "<h1>Hello from Fabl!</h1>",
              headers: %{
                "cache-control" => "private"
              }
            })

  test "non-personalised request" do
    expect_non_personalised_origin_request()

    response =
      build_request()
      |> make_request()
      |> assert_successful_response()

    assert vary_header(response) =~ "authorization,x-authentication-provider"
  end

  test "personalised request" do
    expect_personalised_origin_request()

    response =
      build_request()
      |> personalise_app_request(@token)
      |> make_request()
      |> assert_successful_response()

    assert vary_header(response) =~ "authorization,x-authentication-provider"
  end

  test "invalid auth token" do
    expect_no_origin_request()

    conn =
      build_request()
      |> personalise_app_request("some-token")
      |> make_request()

    assert conn.status == 401
  end

  test "does not use non-personalised cached response as fallback" do
    request = build_request()

    # Store non-personalised response in cache
    response = Map.put(@response, :headers, %{"cache-control" => "public, max-age=60"})
    stub_origin_request({:ok, response})

    request
    |> make_request()
    |> assert_successful_response()

    # Simulate origin failure
    stub_origin_request({:error, :boom})

    conn =
      request
      |> personalise_app_request(@token)
      |> make_request()

    assert conn.status == 500
    {"cache-control", "private, stale-while-revalidate=15, max-age=0"} in conn.resp_headers
  end

  test "internal error in Belfrage" do
    # Simulate an error by making origin return an unexpected response
    stub_origin_request({:foo, :bar})

    request =
      build_request()
      |> personalise_app_request(@token)

    assert_raise(Plug.Conn.WrapperError, fn -> make_request(request) end)

    {status, headers, _body} = sent_resp(request)
    assert status == 500
    assert {"cache-control", "private, stale-while-revalidate=15, max-age=0"} in headers
  end

  describe "personalisation is disabled" do
    setup do
      stub_dial(:personalisation, "off")
      :ok
    end

    test "authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request()
        |> personalise_app_request(@token)
        |> make_request()
        |> assert_successful_response()

      assert vary_header_contains?(response, ["authorization", "x-authentication-provider"])
    end

    test "non-authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request()
        |> make_request()
        |> assert_successful_response()

      assert vary_header_contains?(response, ["authorization", "x-authentication-provider"])
    end
  end

  test "personalisation on and news_articles_personalisation is off" do
    stub_dials(personalisation: "on", news_articles_personalisation: "off")
    expect_personalised_origin_request()

    response =
      build_request()
      |> personalise_app_request(@token)
      |> make_request()
      |> assert_successful_response()

    assert vary_header_contains?(response, ["authorization", "x-authentication-provider"])
  end

  test "personalisation off and news_articles_personalisation is on" do
    stub_dials(personalisation: "off", news_articles_personalisation: "on")
    expect_personalised_origin_request()

    response =
      build_request()
      |> personalise_app_request(@token)
      |> make_request()
      |> assert_successful_response()

    assert vary_header_contains?(response, ["authorization", "x-authentication-provider"])
  end

  describe "non-personalised route" do
    test "authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request_to_non_personalised_route()
        |> personalise_app_request(@token)
        |> make_request()
        |> assert_successful_response()

      refute vary_header_contains?(response, ["authorization", "x-authentication-provider"])
    end

    test "non-authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request_to_non_personalised_route()
        |> make_request()
        |> assert_successful_response()

      refute vary_header_contains?(response, ["authorization", "x-authentication-provider"])
    end
  end

  defp expect_personalised_origin_request() do
    token = AuthToken.valid_access_token()
    bearer = "Bearer #{token}"

    expect(HTTPMock, :execute, fn %{headers: %{"authorization" => ^bearer, "x-authentication-provider" => _}}, :Fabl ->
      {:ok, @response}
    end)
  end

  defp expect_non_personalised_origin_request() do
    expect(HTTPMock, :execute, fn %{headers: %{}}, :Fabl -> {:ok, @response} end)
  end

  defp expect_no_origin_request() do
    expect(HTTPMock, :execute, 0, fn _request, _origin -> nil end)
  end

  defp stub_origin_request(response) do
    expect(HTTPMock, :execute, fn _request, _origin ->
      response
    end)
  end

  defp build_request(
         path \\ "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
       ) do
    :get
    |> conn(path)
    |> Map.put(:host, "news-app.bbc.co.uk")
  end

  defp build_request_to_non_personalised_route() do
    build_request(
      "/app-request/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
    )
  end

  defp make_request(conn) do
    Router.call(conn, [])
  end

  defp assert_successful_response(conn) do
    assert conn.status == 200
    assert conn.resp_body == @response.body
    conn
  end

  defp vary_header(response) do
    response
    |> get_resp_header("vary")
    |> hd()
  end

  defp vary_header_contains?(conn, headers) do
    vary_header =
      conn
      |> vary_header()
      |> String.split(",")
      |> MapSet.new()

    MapSet.subset?(MapSet.new(headers), vary_header)
  end
end
