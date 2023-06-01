defmodule EndToEnd.BbcxPlatformSelectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox
  alias Belfrage.Clients.{LambdaMock, HTTPMock, HTTP.Response}

  import Test.Support.Helper, only: [set_environment: 1]

  @successful_lambda_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}
  @successful_http_response {:ok, %Response{status_code: 200, headers: %{"content-type" => "text/html"}, body: "OK"}}

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  test "the BBCX platform selector points to Webcore" do
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

  test "the BBCX platform selector points to Webcore when cookie-ckns_bbccom_beta is not set" do
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

  test "the BBCX platform selector points to BBCX" do
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

  test "the BBCX platform selector points to Webcore when Cosmos Environment is live" do
    set_environment("live")

    expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
      @successful_lambda_response
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
end
