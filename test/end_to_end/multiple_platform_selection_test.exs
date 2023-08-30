defmodule EndToEnd.MultiplePlatformSelectionTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock, LambdaMock}

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @mozart_news_endpoint Application.compile_env!(:belfrage, :mozart_news_endpoint)
  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @ares_url "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fplatform-selection-with-selector"
  @mozart_url "#{@mozart_news_endpoint}/news/platform-selection-with-selector"

  @mozart_news_resp_body "<h1>Hello from MozartNews!</h1>"
  @lambda_resp_body "<h1>Hello from the Lambda!</h1>"

  setup :clear_preflight_metadata_cache
  setup :clear_cache

  describe "When a preflight pipeline transformer defines platform" do
    test ~s(MozartNews platform is selected in preflight pipeline) do
      url = "#{@mozart_news_endpoint}/platform-selection-with-mozart-news-platform"
      mock_http_call(url, :MozartNews, 200, @mozart_news_resp_body)

      conn =
        conn(:get, "/platform-selection-with-mozart-news-platform")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test ~s(Webcore platform is selected in preflight pipeline) do
      mock_private_lambda_call("SomeRouteStateWithMultipleSpecs.Webcore")

      conn =
        conn(:get, "/platform-selection-with-webcore-platform")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, @lambda_resp_body} = sent_resp(conn)
    end
  end

  describe "When a route with a :platform attribute is used that is a selector" do
    test ~s(webcore platform is used when asset type in ["MAP", "CSP", "PGL", "STY"]) do
      Enum.each(@webcore_asset_types, fn asset_type ->
        clear_preflight_metadata_cache()
        mock_http_call(@ares_url, :Preflight, 200, "{\"data\": {\"type\": \"#{asset_type}\"}}")
        mock_private_lambda_call("AssetTypeWithMultipleSpecs.Webcore")

        conn =
          conn(:get, "/news/platform-selection-with-selector")
          |> Router.call(routefile: Routes.Routefiles.Mock)

        assert {200, _headers, @lambda_resp_body} = sent_resp(conn)
      end)
    end

    test "asset type is cached" do
      asset_type = Enum.random(@webcore_asset_types)
      mock_http_call(@ares_url, :Preflight, 200, "{\"data\": {\"type\": \"#{asset_type}\"}}")
      mock_private_lambda_call("AssetTypeWithMultipleSpecs.Webcore")

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, @lambda_resp_body} = sent_resp(conn)

      mock_private_lambda_call("AssetTypeWithMultipleSpecs.Webcore")

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "cached asset type expires after TTL" do
      asset_type = Enum.random(@webcore_asset_types)
      mock_http_call(@ares_url, :Preflight, 200, "{\"data\": {\"type\": \"#{asset_type}\"}}")
      mock_private_lambda_call("AssetTypeWithMultipleSpecs.Webcore")

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, @lambda_resp_body} = sent_resp(conn)

      mock_http_call(@ares_url, :Preflight, 200, "{\"data\": {\"type\": \"#{asset_type}\"}}")
      mock_private_lambda_call("AssetTypeWithMultipleSpecs.Webcore")

      Process.sleep(Application.get_env(:belfrage, :preflight_metadata_cache)[:default_ttl_ms] + 1)

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, @lambda_resp_body} = sent_resp(conn)
    end

    test ~s(MozartNews platform is used when asset type not in ["MAP", "CSP", "PGL", "STY"]) do
      mock_http_call(@ares_url, :Preflight, 200, "{\"data\": {\"type\": \"SOME_OTHER_ASSET_TYPE\"}}")
      mock_http_call(@mozart_url, :MozartNews, 200, @mozart_news_resp_body)

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, @mozart_news_resp_body} = sent_resp(conn)
    end

    test "MozartNews platform is used when 404 response is returned" do
      mock_http_call(@ares_url, :Preflight, 404, "")
      mock_http_call(@mozart_url, :MozartNews, 200, @mozart_news_resp_body)

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end
  end

  describe "When preflight fails" do
    test "500 is returned if fallback isn't available" do
      mock_http_call(@ares_url, :Preflight, 500, "")

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {500, _headers, _body} = sent_resp(conn)
    end

    test "fallback is returned if available" do
      mock_http_call(@ares_url, :Preflight, 200, "{\"data\": {\"type\": \"STY\"}}")
      mock_public_lambda_call("AssetTypeWithMultipleSpecs.Webcore")

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, headers, @lambda_resp_body} = sent_resp(conn)
      assert "MISS" = get_header_cache_status(headers)

      clear_preflight_metadata_cache()
      mock_http_call(@ares_url, :Preflight, 500, "")

      conn =
        conn(:get, "/news/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, headers, @lambda_resp_body} = sent_resp(conn)
      assert "STALE" = get_header_cache_status(headers)
    end
  end

  defp mock_http_call(req_url, service, resp_status, resp_body) do
    expect(HTTPMock, :execute, fn %HTTP.Request{method: :get, url: ^req_url}, ^service ->
      {:ok, %HTTP.Response{status_code: resp_status, body: resp_body}}
    end)
  end

  defp mock_private_lambda_call(ctx_route_spec), do: mock_lambda_call(ctx_route_spec, "private")

  defp mock_public_lambda_call(ctx_route_spec), do: mock_lambda_call(ctx_route_spec, "public, max-age=60")

  defp mock_lambda_call(ctx_route_spec, cache_control) do
    expect(LambdaMock, :call, fn _credentials, _function_arn, %{headers: %{"ctx-route-spec": ^ctx_route_spec}}, _opts ->
      {:ok,
       %{
         "headers" => %{"cache-control" => cache_control},
         "statusCode" => 200,
         "body" => @lambda_resp_body
       }}
    end)
  end

  defp get_header_cache_status(headers) do
    :proplists.get_value("belfrage-cache-status", headers)
  end
end
