defmodule EndToEnd.MultiplePlatformSelectionTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1, clear_preflight_metadata_cache: 0]
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock, LambdaMock}

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @mozart_news_endpoint Application.compile_env!(:belfrage, :mozart_news_endpoint)
  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  setup :clear_preflight_metadata_cache

  describe "When a preflight pipeline transformer defines platform" do
    test ~s(MozartNews platform is selected in preflight pipeline) do
      url = "#{@mozart_news_endpoint}/platform-selection-with-mozart-news-platform"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/platform-selection-with-mozart-news-platform")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test ~s(Webcore platform is selected in preflight pipeline) do
      expect(LambdaMock, :call, fn _credentials,
                                   _function_arn,
                                   %{headers: %{"ctx-route-spec": "SomeRouteStateWithMultipleSpecs.Webcore"}},
                                   _opts ->
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
        conn(:get, "/platform-selection-with-webcore-platform")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end
  end

  describe "When a route with a :platform attribute is used that is a selector" do
    test ~s(webcore platform is used when asset type in ["MAP", "CSP", "PGL", "STY"]) do
      Enum.each(@webcore_asset_types, fn asset_type ->
        clear_preflight_metadata_cache()
        url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fplatform-selection-with-selector"

        HTTPMock
        |> expect(
          :execute,
          fn %HTTP.Request{
               method: :get,
               url: ^url
             },
             :Preflight ->
            {:ok,
             %HTTP.Response{
               status_code: 200,
               body: "{\"data\": {\"type\": \"#{asset_type}\"}}"
             }}
          end
        )

        expect(LambdaMock, :call, fn _credentials,
                                     _function_arn,
                                     %{headers: %{"ctx-route-spec": "AssetTypeWithMultipleSpecs.Webcore"}},
                                     _opts ->
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
          conn(:get, "/platform-selection-with-selector")
          |> Router.call(routefile: Routes.Routefiles.Mock)

        assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
      end)
    end

    test "asset type is cached" do
      asset_type = Enum.random(@webcore_asset_types)

      url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"#{asset_type}\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials,
                                   _function_arn,
                                   %{headers: %{"ctx-route-spec": "AssetTypeWithMultipleSpecs.Webcore"}},
                                   _opts ->
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
        conn(:get, "/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)

      expect(LambdaMock, :call, fn _credentials,
                                   _function_arn,
                                   %{headers: %{"ctx-route-spec": "AssetTypeWithMultipleSpecs.Webcore"}},
                                   _opts ->
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
        conn(:get, "/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "cached asset type expires after TTL" do
      asset_type = Enum.random(@webcore_asset_types)

      url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"#{asset_type}\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials,
                                   _function_arn,
                                   %{headers: %{"ctx-route-spec": "AssetTypeWithMultipleSpecs.Webcore"}},
                                   _opts ->
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
        conn(:get, "/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"#{asset_type}\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials,
                                   _function_arn,
                                   %{headers: %{"ctx-route-spec": "AssetTypeWithMultipleSpecs.Webcore"}},
                                   _opts ->
        {:ok,
         %{
           "headers" => %{
             "cache-control" => "private"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      Process.sleep(Application.get_env(:belfrage, :preflight_metadata_cache)[:default_ttl_ms] + 1)

      conn =
        conn(:get, "/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test ~s(MozartNews platform is used when asset type not in ["MAP", "CSP", "PGL", "STY"]) do
      ares_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      mozart_url = "#{@mozart_news_endpoint}/platform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^ares_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"SOME_OTHER_ASSET_TYPE\"}}"
           }}
        end
      )
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test "Webcore platform is used when 404 response is returned - all stacks apart from Joan" do
      ares_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^ares_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 404
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _function_arn, _headers, _opts ->
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
        conn(:get, "/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "Webcore platform is used when 500 response is returned - all stacks apart from Joan" do
      ares_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^ares_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 500
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _function_arn, _headers, _opts ->
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
        conn(:get, "/platform-selection-with-selector")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end
  end
end
