defmodule EndToEnd.DotcomPlatformSelectionTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTPMock, HTTP.Response}

  @moduletag :end_to_end

  @successful_http_response {:ok,
                             %Response{
                               status_code: 200,
                               headers: %{"content-type" => "text/html"},
                               body: "OK"
                             }}

  test "a request from the US is routed to the DotCom Newsletters page and the expected vary headers are in the response" do
    expect(HTTPMock, :execute, fn _request, :DotComNewsletters ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/newsletters")
      |> put_req_header("x-ip_is_uk_combined", "no")
      |> Router.call(routefile: Routes.Routefiles.Main.Test)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end

  test "a request from the UK for /newsletters is routed to the domestic homepage and the expected vary headers are in the response" do
    conn =
      conn(:get, "/newsletters")
      |> put_req_header("x-ip_is_uk_combined", "yes")
      |> Router.call(routefile: Routes.Routefiles.Main.Test)

    assert {302, headers, ""} = sent_resp(conn)
    assert {"location", "/"} in headers

    assert {"vary",
            "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"} in headers
  end

  test "a request missing the x-ip_is_uk_combined header for /newsletters is routed to the DotCom Newsletters page and the expected vary headers are in the response" do
    expect(HTTPMock, :execute, fn _request, :DotComNewsletters ->
      @successful_http_response
    end)

    conn =
      conn(:get, "/newsletters")
      |> Router.call(routefile: Routes.Routefiles.Main.Test)

    assert get_resp_header(conn, "vary") == [
             "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
           ]
  end
end
