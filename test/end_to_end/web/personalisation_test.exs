defmodule EndToEnd.Web.PersonalisationTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.{CachingHelper, PersonalisationHelper}
  import Test.Support.Helper, only: [set_environment: 1, set_bbc_id_availability: 1]
  alias Fixtures.AuthToken

  @token AuthToken.valid_access_token()
  @expired_token AuthToken.expired_access_token()

  alias BelfrageWeb.Router
  alias Belfrage.Clients.{LambdaMock, HTTPMock, HTTP}
  alias Fixtures.AuthToken

  @moduletag :end_to_end

  setup do
    clear_cache()
  end

  @response %{
    "headers" => %{
      "cache-control" => "private"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  test "non-personalised request" do
    expect_non_personalised_origin_request()

    response =
      build_request()
      |> make_request()
      |> assert_successful_response()

    assert vary_header(response) =~ "x-id-oidc-signedin"
  end

  test "personalised request" do
    token = AuthToken.valid_access_token()
    expect_personalised_origin_request(token)

    response =
      build_request()
      |> personalise_request(token)
      |> make_request()
      |> assert_successful_response()

    assert vary_header(response) =~ "x-id-oidc-signedin"
    [cache_control] = get_resp_header(response, "cache-control")
    assert cache_control == "private, stale-if-error=90, stale-while-revalidate=30"
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

    response =
      request
      |> personalise_request()
      |> make_request()
      |> assert_successful_response()

    [cache_control] = get_resp_header(response, "cache-control")
    assert cache_control == "private"

    assert ["STALE"] = get_resp_header(response, "belfrage-cache-status")
  end

  test "switch from personalised to non-personalised route and request" do
    request = build_request("/personalised-to-non-personalised")

    expect(HTTPMock, :execute, fn %{headers: _headers}, :MozartNews ->
      response = %HTTP.Response{
        headers: %{
          "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=30"
        },
        status_code: 200,
        body: "<h1>Hello</h1>"
      }

      {:ok, response}
    end)

    conn =
      request
      |> personalise_request()
      |> make_request()

    [cache_control] = get_resp_header(conn, "cache-control")
    assert cache_control == "public, stale-if-error=90, stale-while-revalidate=30, max-age=30"
    assert conn.status == 200
    assert conn.resp_body == "<h1>Hello</h1>"
  end

  test "internal error in Belfrage" do
    # Simulate an error by making origin return an unexpected response
    stub_origin_request(response: {:foo, :bar})

    request =
      build_request()
      |> personalise_request()

    assert_raise(Plug.Conn.WrapperError, fn -> make_request(request) end)

    {status, headers, _body} = sent_resp(request)
    assert status == 500
    # Errors returned in response to personalised requests must be private
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
        |> personalise_request()
        |> make_request()
        |> assert_successful_response()

      refute vary_header(response) =~ "x-id-oidc-signedin"
    end

    test "non-authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request()
        |> make_request()
        |> assert_successful_response()

      refute vary_header(response) =~ "x-id-oidc-signedin"
    end
  end

  describe "personalisation on and news_articles_personalisation is off" do
    test "request personalised news article" do
      stub_dials(personalisation: "on", news_articles_personalisation: "off")

      expect_non_personalised_origin_request()

      response =
        build_request("/personalised-news-article-page")
        |> personalise_request()
        |> make_request()
        |> assert_successful_response()

      refute vary_header(response) =~ "x-id-oidc-signedin"
    end

    test "request other personalised page" do
      stub_dials(personalisation: "on", news_articles_personalisation: "off")

      token = AuthToken.valid_access_token()
      expect_personalised_origin_request(token)

      response =
        build_request()
        |> personalise_request(token)
        |> make_request()
        |> assert_successful_response()

      assert vary_header(response) =~ "x-id-oidc-signedin"
    end
  end

  describe "non-personalised route" do
    test "authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request_to_non_personalised_route()
        |> personalise_request()
        |> make_request()
        |> assert_successful_response()

      refute vary_header(response) =~ "x-id-oidc-signedin"
    end

    test "non-authenticated request" do
      expect_non_personalised_origin_request()

      response =
        build_request_to_non_personalised_route()
        |> make_request()
        |> assert_successful_response()

      refute vary_header(response) =~ "x-id-oidc-signedin"
    end
  end

  describe "token is proxied when" do
    test "personalisation is enabled and request contains correct values" do
      # This includes:
      #    * valid x-id-oidc-signedin header
      #    * valid ckns_atkn cookie
      #    * *.bbc.co.uk host
      #    * URI that matches against a RouteSpec with :personalisation "on" (implicitly set to "on" here)
      #    * personalisation dial is on

      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        assert headers[:authorization] == "Bearer #{@token}"
        assert headers[:"x-authentication-provider"]
        assert headers[:"pers-env"]
        assert headers[:"ctx-pii-allow-personalisation"]
        assert headers[:"ctx-pii-age-bracket"]
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end
  end

  describe "token is not proxied when" do
    test "request does not have a *.bbc.co.uk host" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.com")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "request has no x-id-oidc-signedin header or ckns_atkn cookie" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "request has x-id-oidc-signedin header of 0" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "0")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "request has invalid x-id-oidc-signedin header" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "foo")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "request has invalid ckns_atkn cookie" do
      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=some token")
        |> make_request()

      assert conn.status == 302

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers

      assert {"location",
              "https://session.test.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fmy%2Fsession%2Fwebcore-platform"} in conn.resp_headers

      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "request has expired ckns_atkn cookie on test" do
      expect_no_origin_request()

      conn =
        build_request()
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@expired_token}")
        |> make_request()

      assert conn.status == 302

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers

      assert {"location",
              "https://session.test.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fmy%2Fsession%2Fwebcore-platform"} in conn.resp_headers

      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "request with expired ckns_atkn cookie on live" do
      set_environment("live")

      expect_no_origin_request()

      conn =
        build_request()
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@expired_token}")
        |> make_request()

      assert conn.status == 302

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers

      assert {"location",
              "https://session.test.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fmy%2Fsession%2Fwebcore-platform"} in conn.resp_headers

      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "the corresponding RouteSpec does not have :personalisation on, and private cache control from origin is preserved" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]

        {:ok,
         %{
           "headers" => %{
             "cache-control" => "private"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        :get
        |> conn("/200-ok-response")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "the corresponding RouteSpec does not have :personalisation on, and public cache control from origin is preserved" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]

        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        :get
        |> conn("/200-ok-response")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "personalisation dial is off, and private cache directive from origin is preserved" do
      stub_dials(personalisation: "off")

      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]

        {:ok,
         %{
           "headers" => %{
             "cache-control" => "private"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "personalisation dial is off, and public cache directive from origin is preserved" do
      stub_dials(personalisation: "off")

      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]

        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "BBCID is not available, and private cache control from origin is preserved" do
      set_bbc_id_availability(false)

      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"] == "true"
        refute headers[:"ctx-pii-age-bracket"]

        {:ok,
         %{
           "headers" => %{
             "cache-control" => "private"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end

    test "BBCID is not available, and public cache control from origin is preserved" do
      set_bbc_id_availability(false)

      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]

        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@token}")
        |> make_request()

      assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30"} in conn.resp_headers
      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end
  end

  describe "x-id-oidc-signedin vary header is added when" do
    test "the corresponding RouteSpec has personalisation on" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"] == "true"
        refute headers[:"ctx-pii-age-bracket"]
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/my/session/webcore-platform")
        |> Map.put(:host, "www.bbc.co.uk")
        |> make_request()

      assert vary_header(conn) =~ "x-id-oidc-signedin"
    end
  end

  describe "x-id-oidc-signedin vary header is not added when" do
    test "the corresponding RouteSpec does not have personalisation on" do
      expect(LambdaMock, :call, fn _role_arn, _function_arn, %{headers: headers}, _opts ->
        refute headers[:authorization] == "Bearer #{@token}"
        refute headers[:"x-authentication-provider"]
        refute headers[:"pers-env"]
        refute headers[:"ctx-pii-allow-personalisation"]
        refute headers[:"ctx-pii-age-bracket"]
        {:ok, @response}
      end)

      conn =
        :get
        |> conn("/200-ok-response")
        |> Map.put(:host, "www.bbc.co.uk")
        |> make_request()

      refute vary_header(conn) =~ "x-id-oidc-signedin"
    end
  end

  test "personalised responses are not cached" do
    expect(LambdaMock, :call, fn _role_arn, _function_arn, %{}, _opts ->
      {:ok, @response}
    end)

    :get
    |> conn("/my/session/webcore-platform")
    |> Map.put(:host, "www.bbc.co.uk")
    |> put_req_header("x-id-oidc-signedin", "1")
    |> put_req_header("cookie", "ckns_atkn=#{@token}")
    |> make_request()

    assert :ets.tab2list(:cache) == []
  end

  defp expect_origin_request(fun, opts \\ []) do
    expect(LambdaMock, :call, fn _role_arn, _function_arn, request, _opts ->
      fun.(request)
      Keyword.get(opts, :response, {:ok, @response})
    end)
  end

  defp expect_no_origin_request() do
    expect(LambdaMock, :call, 0, fn _role_arn, _function_arn, _request, _opts -> nil end)
  end

  defp expect_non_personalised_origin_request() do
    expect_origin_request(fn %{headers: headers} ->
      refute headers[:authorization]
      refute headers[:"x-authentication-provider"]
      refute headers[:"pers-env"]
      refute headers[:"ctx-pii-allow-personalisation"]
      refute headers[:"ctx-pii-age-bracket"]
    end)
  end

  defp expect_personalised_origin_request(token) do
    expect_origin_request(fn %{headers: headers} ->
      assert headers[:authorization] == "Bearer #{token}"
      assert headers[:"x-authentication-provider"]
      assert headers[:"pers-env"]
      assert headers[:"ctx-pii-allow-personalisation"] == "true"
      assert headers[:"ctx-pii-age-bracket"]
    end)
  end

  defp stub_origin_request(opts) do
    expect_origin_request(fn _req -> nil end, opts)
  end

  defp build_request(path \\ "/my/session/webcore-platform") do
    :get
    |> conn(path)
    |> Map.put(:host, "www.bbc.co.uk")
  end

  defp build_request_to_non_personalised_route() do
    build_request("/")
  end

  defp make_request(conn) do
    Router.call(conn, routefile: Routes.Routefiles.Mock)
  end

  defp assert_successful_response(conn) do
    assert conn.status == 200
    assert conn.resp_body == @response["body"]
    conn
  end

  defp vary_header(response) do
    response
    |> get_resp_header("vary")
    |> hd()
  end
end
