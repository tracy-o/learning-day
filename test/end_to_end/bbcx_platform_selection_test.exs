defmodule EndToEnd.BBCXPlatformSelectionTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox
  alias Belfrage.Clients.{HTTP, LambdaMock, HTTPMock, HTTP.Response}

  import Test.Support.Helper, only: [set_environment: 1]

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)

  @successful_lambda_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}
  @successful_http_response {:ok,
                             %Response{
                               status_code: 200,
                               headers: %{"content-type" => "text/html"},
                               body: "OK"
                             }}

  setup do
    :ets.delete_all_objects(:cache)
    stub_dials(bbcx_enabled: "true")
    set_environment("live")
    :ok
  end

  test "the BBCX Webcore platform selector points to Webcore" do
    expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
      @successful_lambda_response
    end)

    conn =
      conn(:get, "https://www.bbc.com/news/articles/c5ll353v7y9o")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX Webcore platform selector points to Webcore when cookie-ckns_bbccom_beta is not set" do
    expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
      @successful_lambda_response
    end)

    conn =
      conn(:get, "https://www.bbc.com/news/articles/c5ll353v7y9o")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX Webcore platform selector points to BBCX" do
    expect(HTTPMock, :execute, fn _request, :BBCX ->
      @successful_http_response
    end)

    conn =
      conn(:get, "https://www.bbc.com/news/articles/c5ll353v7y9o")
      |> put_req_header("x-country", "us")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "for News CPS content when the environment allows, the BBCX platform selector points to BBCX" do
    fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2F62729302"

    HTTPMock
    |> expect(
      :execute,
      fn %HTTP.Request{
           method: :get,
           url: ^fabl_url
         },
         :Preflight ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"type\": \"STY\"}}"
         }}
      end
    )

    expect(HTTPMock, :execute, fn _request, :BBCX ->
      @successful_http_response
    end)

    conn =
      conn(:get, "https://www.bbc.com/news/62729302")
      |> put_req_header("x-country", "us")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX MozartNews platform selector points to MozartNews" do
    expect(HTTPMock, :execute, 1, fn _request, :MozartNews ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-news")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX MozartNews platform selector points to MozartNews when cookie-ckns_bbccom_beta is not set" do
    expect(HTTPMock, :execute, 1, fn _request, :MozartNews ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-news")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX MozartNews platform selector points to BBCX" do
    expect(HTTPMock, :execute, fn _request, :BBCX ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-news")
      |> put_req_header("x-country", "us")
      |> put_req_header("x-bbc-edge-host", "bbc.com")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX MozartSport platform selector points to MozartSport" do
    expect(HTTPMock, :execute, 1, fn _request, :MozartSport ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-sport")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX MozartSport platform selector points to MozartSport when cookie-ckns_bbccom_beta is not set" do
    expect(HTTPMock, :execute, 1, fn _request, :MozartSport ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-sport")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "the BBCX MozartSport platform selector points to BBCX" do
    expect(HTTPMock, :execute, fn _request, :BBCX ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-sport")
      |> put_req_header("x-country", "us")
      |> put_req_header("x-bbc-edge-host", "bbc.com")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end
end
