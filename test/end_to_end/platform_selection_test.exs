defmodule EndToEnd.PlatformSelectionTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [build_request_uri: 1]

  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock, LambdaMock}

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @mozart_news_endpoint Application.compile_env!(:belfrage, :mozart_news_endpoint)
  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  describe "When a route with a :platform attribute is used that is a platform" do
    test ~s(MozartNews platform is used when platform is "MozartNews") do
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
        conn(:get, build_request_uri(path: "/platform-selection-with-mozart-news-platform"))
        |> Router.call([])

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test ~s(Webcore platform is used when platform is "Webcore") do
      expect(LambdaMock, :call, fn _credentials,
                                   _function_arn,
                                   %{headers: %{"ctx-route-spec": "SomeRouteStateWithoutPlatformAttribute.Webcore"}},
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
        conn(:get, build_request_uri(path: "/platform-selection-with-webcore-platform"))
        |> Router.call([])

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end
  end

  describe "When a route with a :platform attribute is used that is a selector" do
    test ~s(webcore platform is used when asset type in ["MAP", "CSP", "PGL", "STY"]) do
      url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      Enum.each(@webcore_asset_types, fn asset_type ->
        HTTPMock
        |> expect(
          :execute,
          fn %HTTP.Request{
               method: :get,
               url: ^url
             },
             :Fabl ->
            {:ok,
             %HTTP.Response{
               status_code: 200,
               body: "{\"data\": {\"assetType\": \"#{asset_type}\"}}"
             }}
          end
        )

        expect(LambdaMock, :call, fn _credentials,
                                     _function_arn,
                                     %{headers: %{"ctx-route-spec": "SomeRouteStateWithoutPlatformAttribute.Webcore"}},
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
          conn(:get, build_request_uri(path: "/platform-selection-with-selector"))
          |> Router.call([])

        assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
      end)
    end

    test ~s(MozartNews platform is used when asset type not in ["MAP", "CSP", "PGL", "STY"]) do
      ares_url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      mozart_url = "#{@mozart_news_endpoint}/platform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^ares_url
           },
           :Fabl ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"assetType\": \"SOME_OTHER_ASSET_TYPE\"}}"
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
        |> Router.call([])

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test ~s(MozartNews platform is used when 404 response is returned) do
      ares_url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      mozart_url = "#{@mozart_news_endpoint}/platform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^ares_url
           },
           :Fabl ->
          {:ok,
           %HTTP.Response{
             status_code: 404
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
        conn(:get, build_request_uri(path: "/platform-selection-with-selector"))
        |> Router.call([])

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test "When an asset type cannot be retrieved" do
      conn = conn(:get, build_request_uri(path: "/platform-selection-with-selector"))
      url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fplatform-selection-with-selector"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^url
           },
           :Fabl ->
          {:ok,
           %HTTP.Response{
             status_code: 500
           }}
        end
      )

      Router.call(conn, [])

      assert {500, _headers, _body} = sent_resp(conn)
    end
  end
end
