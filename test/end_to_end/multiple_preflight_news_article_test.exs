defmodule EndToEnd.MultiplePreflightNewsArticleTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1]
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock, LambdaMock}

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @mozart_news_endpoint Application.compile_env!(:belfrage, :mozart_news_endpoint)
  @path "/news/uk-87654321"

  @mozart_news_resp_body "<h1>Hello from MozartNews!</h1>"
  @lambda_resp_body "<h1>Hello from the Lambda!</h1>"
  @bbcx_resp_body "<h1>Hello from BBCX!</h1>"

  setup :clear_preflight_metadata_cache

  describe "News article route behaviour" do
    test "when asset type is a Web Core asset" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
      mock_http_call(fabl_url, :Preflight, 200, "{\"data\": {\"type\": \"STY\"}}")

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => @lambda_resp_body
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, @lambda_resp_body} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
      mock_http_call(fabl_url, :Preflight, 200, "{\"data\": {\"type\": \"FIX\"}}")

      mozart_url = "#{@mozart_news_endpoint}#{@path}"
      mock_http_call(mozart_url, :MozartNews, 200, @mozart_news_resp_body)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test "when asset type is unknown due to a data error" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
      mock_http_call(fabl_url, :Preflight, 500, "")

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {500, _headers, _body} = sent_resp(conn)
    end

    test "when resource is not found" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
      mock_http_call(fabl_url, :Preflight, 404, "")

      mozart_url = "#{@mozart_news_endpoint}#{@path}"
      mock_http_call(mozart_url, :MozartNews, 200, @mozart_news_resp_body)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, @mozart_news_resp_body} = sent_resp(conn)
    end

    test "when path is invalid" do
      mozart_url = "#{@mozart_news_endpoint}/news/.invalid"
      mock_http_call(mozart_url, :MozartNews, 200, @mozart_news_resp_body)

      conn =
        conn(:get, "/news/.invalid")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, @mozart_news_resp_body} = sent_resp(conn)
    end

    test "when asset type is a Web Core asset and request is BBCX" do
      stub_dials(bbcx_enabled: "true")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
      mock_http_call(fabl_url, :Preflight, 200, "{\"data\": {\"type\": \"STY\"}}")

      bbcx_url = "https://web.test.bbcx-internal.com/news/uk-87654321"
      mock_http_call(bbcx_url, :BBCX, 200, @bbcx_resp_body)

      conn =
        conn(:get, "/news/uk-87654321")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "us")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, @bbcx_resp_body} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and request is BBCX" do
      stub_dials(bbcx_enabled: "true")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
      mock_http_call(fabl_url, :Preflight, 200, "{\"data\": {\"type\": \"FIX\"}}")

      bbcx_url = "https://web.test.bbcx-internal.com/news/uk-87654321"
      mock_http_call(bbcx_url, :BBCX, 200, @bbcx_resp_body)

      conn =
        conn(:get, "/news/uk-87654321")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "us")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, @bbcx_resp_body} = sent_resp(conn)
    end
  end

  test "when asset type is a Web Core asset and request is BBCX" do
    stub_dials(bbcx_enabled: "true")

    fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
    mock_http_call(fabl_url, :Preflight, 200, "{\"data\": {\"type\": \"STY\"}}")

    bbcx_url = "https://web.test.bbcx-internal.com/news/uk-87654321"
    mock_http_call(bbcx_url, :BBCX, 200, @bbcx_resp_body)

    conn =
      conn(:get, "/news/uk-87654321")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> put_req_header("x-bbc-edge-host", "www.bbc.com")
      |> put_req_header("x-country", "us")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert {200, _headers, @bbcx_resp_body} = sent_resp(conn)
  end

  test "when asset type is a Mozart asset and request is BBCX" do
    stub_dials(bbcx_enabled: "true")

    fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"
    mock_http_call(fabl_url, :Preflight, 200, "{\"data\": {\"type\": \"FIX\"}}")

    bbcx_url = "https://web.test.bbcx-internal.com/news/uk-87654321"
    mock_http_call(bbcx_url, :BBCX, 200, @bbcx_resp_body)

    conn =
      conn(:get, "/news/uk-87654321")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> put_req_header("x-bbc-edge-host", "www.bbc.com")
      |> put_req_header("x-country", "us")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert {200, _headers, @bbcx_resp_body} = sent_resp(conn)
  end

  defp mock_http_call(req_url, service, resp_status, resp_body) do
    expect(HTTPMock, :execute, fn %HTTP.Request{method: :get, url: ^req_url}, ^service ->
      {:ok, %HTTP.Response{status_code: resp_status, body: resp_body}}
    end)
  end
end
