defmodule EndToEnd.MergedAllowlistsTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{LambdaMock, HTTPMock}
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @mozart_news_endpoint Application.compile_env(:belfrage, :mozart_news_endpoint)
  @dotcom_culture_endpoint Application.compile_env(:belfrage, :dotcom_culture_endpoint)
  @bbcx_endpoint Application.compile_env(:belfrage, :bbcx_endpoint)

  @http_response %Belfrage.Clients.HTTP.Response{
    status_code: 200,
    body: "some body",
    headers: %{}
  }

  @lambda_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  describe "Processor merges headers and query params allowlists for multi-platform specs" do
    test "for SomeRouteStateWithMultipleSpecs.Webcore spec" do
      qs = "custom_qs=1&webcore_qparam=abc"
      path = "platform-selection-with-mozart-news-platform"
      url = "#{@mozart_news_endpoint}/#{path}?#{qs}"

      expect(HTTPMock, :execute, fn %Belfrage.Clients.HTTP.Request{
                                      method: :get,
                                      url: ^url,
                                      headers: %{
                                        "mozartnews-header" => "mozartnews-header-val",
                                        "webcore-header" => "webcore-header-val"
                                      }
                                    },
                                    :MozartNews ->
        {:ok, @http_response}
      end)

      conn =
        conn(:get, "/#{path}?#{qs}")
        |> put_req_header("webcore-header", "webcore-header-val")
        |> put_req_header("mozartnews-header", "mozartnews-header-val")
        |> put_req_header("filtered-header", "filtered-header-val")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _body} = sent_resp(conn)
    end

    test "for SomeRouteStateWithMultipleSpecs.MozartNews spec" do
      qs = "custom_qs=1&webcore_qparam=abc"
      path = "/platform-selection-with-webcore-platform"

      expect(LambdaMock, :call, fn _credentials,
                                   _arn,
                                   %{
                                     path: ^path,
                                     queryStringParameters: %{
                                       "custom_qs" => "1",
                                       "webcore_qparam" => "abc"
                                     }
                                   },
                                   _ ->
        @lambda_response
      end)

      conn =
        conn(:get, "#{path}?#{qs}")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _body} = sent_resp(conn)
    end

    test "for DotComCulture.DotComCulture spec" do
      qs = "custom_qs=1"
      path = "/culture"
      url = "#{@dotcom_culture_endpoint}/#{path}?#{qs}"

      expect(HTTPMock, :execute, fn %Belfrage.Clients.HTTP.Request{
                                      method: :get,
                                      url: ^url,
                                      headers: %{"cookie-ckns_bbccom_beta" => "1"}
                                    },
                                    :DotComCulture ->
        {:ok, @http_response}
      end)

      conn =
        conn(:get, "https://www.bbc.com/#{path}?#{qs}")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("filtered-header", "filtered-header-val")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {200, _headers, _body} = sent_resp(conn)
    end

    test "for DotComCulture.BBCX spec" do
      stub_dials(bbcx_enabled: "true")
      qs = "custom_qs=1"
      path = "/culture"
      url = "#{@bbcx_endpoint}/#{path}?#{qs}"

      expect(HTTPMock, :execute, fn %Belfrage.Clients.HTTP.Request{
                                      method: :get,
                                      url: ^url,
                                      headers: %{"cookie-ckns_bbccom_beta" => "1"}
                                    },
                                    :BBCX ->
        {:ok, @http_response}
      end)

      conn =
        conn(:get, "https://www.bbc.com/#{path}?#{qs}")
        |> put_req_header("x-country", "us")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("filtered-header", "filtered-header-val")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {200, _headers, _body} = sent_resp(conn)
    end
  end
end
