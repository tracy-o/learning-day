defmodule EndToEnd.BBCXPlatformSelectionTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox
  alias Belfrage.Clients.{LambdaMock, HTTPMock, HTTP.Response}

  import Test.Support.Helper, only: [set_environment: 1, set_env: 4]

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
    :ok
  end

  test "the BBCX Webcore platform selector points to Webcore" do
    set_environment("test")

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
    set_environment("test")

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
    set_environment("test")

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

  test "the BBCX platform selector points to Webcore and doesn't vary on cookie-ckns_bbccom_beta when Cosmos Environment is live" do
    set_env(:belfrage, :production_environment, "live", &Belfrage.RouteSpecManager.update_specs/0)
    Belfrage.RouteSpecManager.update_specs()

    expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
      @successful_lambda_response
    end)

    conn =
      conn(:get, "https://www.bbc.com/news/articles/c5ll353v7y9o")
      |> put_req_header("x-country", "us")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
           ]
  end

  test "for News CPS content when the environment allows, the BBCX platform selector points to BBCX" do
    set_environment("test")

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
    set_environment("test")

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
    set_environment("test")

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
    stub_dial(:bbcx_enabled, "true")
    set_environment("test")

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

  test "the BBCX MozartNews platform selector points to MozartNews and don't vary on cookie-ckns_bbccom_beta when Cosmos Environment is live" do
    set_env(:belfrage, :production_environment, "live", &Belfrage.RouteSpecManager.update_specs/0)
    Belfrage.RouteSpecManager.update_specs()

    expect(HTTPMock, :execute, 1, fn _request, :MozartNews ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-news")
      |> put_req_header("x-country", "us")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
           ]
  end

  test "the BBCX MozartSport platform selector points to MozartSport" do
    set_environment("test")

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
    set_environment("test")

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
    set_environment("test")

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

  test "the BBCX MozartSport platform selector points to MozartSport and don't vary on cookie-ckns_bbccom_beta when Cosmos Environment is live" do
    set_env(:belfrage, :production_environment, "live", &Belfrage.RouteSpecManager.update_specs/0)
    Belfrage.RouteSpecManager.update_specs()

    expect(HTTPMock, :execute, 1, fn _request, :MozartSport ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/bbcx-platform-selector-mozart-sport")
      |> put_req_header("x-country", "us")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
           ]
  end
end
