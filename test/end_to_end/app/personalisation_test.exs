defmodule EndToEnd.App.PersonalisationTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.{CachingHelper, PersonalisationHelper}
  import Test.Support.Helper, only: [set_environment: 1, set_bbc_id_availability: 1]

  alias BelfrageWeb.Router
  alias Belfrage.{Clients.HTTPMock, Clients.HTTP}
  alias Fixtures.AuthToken

  @token AuthToken.valid_access_token()
  @expired_token AuthToken.expired_access_token()

  @moduletag :end_to_end

  @response HTTP.Response.new(%{
              status_code: 200,
              body: "<h1>Hello from Fabl!</h1>",
              headers: %{
                "cache-control" => "private"
              }
            })

  setup :clear_cache

  describe "personalised route" do
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
      assert {"cache-control", "private, stale-while-revalidate=15, max-age=0"} in conn.resp_headers
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

      conn =
        build_request()
        |> personalise_app_request(@token)
        |> make_request()

      {status, headers, body} = sent_resp(conn)
      assert status == 204
      assert body == ""
      assert {"cache-control", "private"} in headers
    end
  end

  describe "personalised route and expired auth. token" do
    test "invalid auth token on test prod. env." do
      set_environment("test")
      expect_no_origin_request()

      conn =
        build_request()
        |> personalise_app_request(AuthToken.expired_access_token())
        |> make_request()

      assert conn.status == 401
    end

    test "expired auth token on live prod. env." do
      set_environment("live")
      expect_no_origin_request()

      conn =
        build_request()
        |> personalise_app_request(AuthToken.expired_access_token())
        |> make_request()

      assert conn.status == 401
    end
  end

  describe "personalisation is disabled" do
    setup do
      stub_dial(:personalisation, "off")
      :ok
    end

    test "authenticated request" do
      conn =
        build_request()
        |> personalise_app_request(@token)
        |> make_request()

      {status, headers, body} = sent_resp(conn)
      assert status == 204
      assert body == ""
      assert {"cache-control", "private"} in headers
    end

    test "non-authenticated request" do
      conn =
        build_request()
        |> make_request()

      {status, headers, body} = sent_resp(conn)
      assert status == 204
      assert body == ""
      assert {"cache-control", "private"} in headers
    end
  end

  describe "non-personalised route" do
    test "authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request_to_non_personalised_route()
        |> personalise_app_request(@token)
        |> make_request()
        |> assert_successful_response()

      refute vary_header_contains?(response, ["authorization"])
      refute vary_header_contains?(response, ["x-authentication-provider"])
    end

    test "non-authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request_to_non_personalised_route()
        |> make_request()
        |> assert_successful_response()

      refute vary_header_contains?(response, ["authorization"])
      refute vary_header_contains?(response, ["x-authentication-provider"])
    end
  end

  describe "token is proxied when" do
    setup do
      start_supervised!({RouteState, {"AppPersonalisation", "Fabl"}})
      :ok
    end

    test "personalisation is enabled and request contains correct values" do
      # This includes:
      #    * valid authorization token
      #    * *.bbc.co.uk host
      #    * URI that matches against a RouteSpec with :personalisation "on" (implicitly set to "on" here)
      #    * personalisation dial is off

      expect(HTTPMock, :execute, fn %{headers: headers}, :Fabl ->
        assert headers["authorization"] == "Bearer #{@token}"
        assert headers["x-authentication-provider"] == "idv5"
        {:ok, @response}
      end)

      conn =
        :get
        |> conn(
          "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> put_req_header("authorization", "Bearer #{@token}")
        |> make_request()

      # also check response headers
      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end

    test "request does not have a *.bbc.co.uk host" do
      expect(HTTPMock, :execute, fn %{headers: headers}, :Fabl ->
        assert headers["authorization"] == "Bearer #{@token}"
        refute headers["x-authentication-provider"] == "idv5"
        {:ok, @response}
      end)

      conn =
        :get
        |> conn(
          "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )
        |> Map.put(:host, "news-app.bbc.com")
        |> put_req_header("authorization", "Bearer #{@token}")
        |> make_request()

      # also check response headers
      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end
  end

  describe "token is not proxied when" do
    test "request has no authentication header" do
      start_supervised!({RouteState, {"AppPersonalisation", "Fabl"}})

      expect(HTTPMock, :execute, fn %{headers: headers}, :Fabl ->
        refute headers["authorization"] == "Bearer #{@token}"
        refute headers["x-authentication-provider"] == "idv5"
        {:ok, @response}
      end)

      conn =
        :get
        |> conn(
          "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> make_request()

      # also check response headers
      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end

    test "request has invalid authorization header" do
      start_supervised!({RouteState, {"AppPersonalisation", "Fabl"}})

      expect_no_origin_request()

      conn =
        :get
        |> conn(
          "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> put_req_header("authorization", "Bearer some-token")
        |> make_request()

      assert conn.status == 401

      # also check response headers
      assert {"cache-control", "private, stale-while-revalidate=15, max-age=0"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end

    test "request has expired authorization header on test" do
      start_supervised!({RouteState, {"AppPersonalisation", "Fabl"}})

      expect_no_origin_request()

      conn =
        build_request()
        |> put_req_header("authorization", "Bearer #{@expired_token}")
        |> make_request()

      assert conn.status == 401

      # also check response headers
      assert {"cache-control", "private, stale-while-revalidate=15, max-age=0"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end

    test "request with expired authorization header on live" do
      start_supervised!({RouteState, {"AppPersonalisation", "Fabl"}})

      set_environment("live")

      expect_no_origin_request()

      conn =
        build_request()
        |> put_req_header("authorization", "Bearer #{@expired_token}")
        |> make_request()

      assert conn.status == 401

      # also check response headers
      assert {"cache-control", "private, stale-while-revalidate=15, max-age=0"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end

    test "the corresponding RouteSpec does not have :personalisation on, and preserves public cache directive from origin" do
      start_supervised!({Belfrage.RouteState, {"FablData", "Fabl"}})

      expect(HTTPMock, :execute, fn %{headers: headers}, :Fabl ->
        refute headers["authorization"] == "Bearer #{@token}"
        refute headers["x-authentication-provider"] == "idv5"

        {:ok,
         HTTP.Response.new(%{
           status_code: 200,
           body: "<h1>Hello from Fabl!</h1>",
           headers: %{
             "cache-control" => "public"
           }
         })}
      end)

      conn =
        :get
        |> conn("/app-request/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios")
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> put_req_header("authorization", "Bearer #{@token}")
        |> make_request()

      # also check response headers
      assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "authorization"
      refute vary_header(conn) =~ "x-authentication-provider"
    end

    test "the corresponding RouteSpec does not have :personalisation on, and preserves private cache directive from origin" do
      start_supervised!({Belfrage.RouteState, {"FablData", "Fabl"}})

      expect(HTTPMock, :execute, fn %{headers: headers}, :Fabl ->
        refute headers["authorization"] == "Bearer #{@token}"
        refute headers["x-authentication-provider"] == "idv5"

        {:ok,
         HTTP.Response.new(%{
           status_code: 200,
           body: "<h1>Hello from Fabl!</h1>",
           headers: %{
             "cache-control" => "private"
           }
         })}
      end)

      conn =
        :get
        |> conn("/app-request/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios")
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> put_req_header("authorization", "Bearer #{@token}")
        |> make_request()

      # also check response headers
      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "authorization"
      refute vary_header(conn) =~ "x-authentication-provider"
    end

    test "personalisation dial is off" do
      start_supervised!({Belfrage.RouteState, {"AppPersonalisation", "Fabl"}})

      stub_dials(personalisation: "off")

      conn =
        :get
        |> conn(
          "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> put_req_header("authorization", "Bearer #{@token}")
        |> make_request()

      assert conn.status == 204

      assert {"cache-control", "private"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end

    test "BBCID is not available" do
      set_bbc_id_availability(false)

      start_supervised!({Belfrage.RouteState, {"AppPersonalisation", "Fabl"}})

      conn =
        :get
        |> conn(
          "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> put_req_header("authorization", "Bearer #{@token}")
        |> make_request()

      assert conn.status == 204

      assert {"cache-control", "private"} in conn.resp_headers
      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end
  end

  describe "authorization vary headers are added when" do
    test "the corresponding RouteSpec has personalisation on" do
      start_supervised!({Belfrage.RouteState, {"AppPersonalisation", "Fabl"}})

      expect(HTTPMock, :execute, fn _request, :Fabl ->
        {:ok, @response}
      end)

      conn =
        :get
        |> conn(
          "/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> make_request()

      assert vary_header(conn) =~ "authorization"
      assert vary_header(conn) =~ "x-authentication-provider"
    end
  end

  describe "authorization vary headers are not added when" do
    test "the corresponding RouteSpec does not have personalisation on" do
      start_supervised!({Belfrage.RouteState, {"FablData", "Fabl"}})

      expect(HTTPMock, :execute, fn _request, :Fabl ->
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/app-request/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios")
        |> Map.put(:host, "news-app.bbc.co.uk")
        |> make_request()

      refute vary_header(conn) =~ "authorization"
      refute vary_header(conn) =~ "x-authentication-provider"
    end
  end

  test "personalised responses are not cached" do
    start_supervised!({RouteState, {"AppPersonalisation", "Fabl"}})

    expect(HTTPMock, :execute, fn %{}, :Fabl ->
      {:ok, @response}
    end)

    :get
    |> conn("/app-request/p/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios")
    |> Map.put(:host, "news-app.bbc.co.uk")
    |> put_req_header("authorization", "Bearer #{@token}")
    |> make_request()

    assert :ets.tab2list(:cache) == []
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
