defmodule BelfrageWeb.Plugs.HttpRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.HttpRedirector

  defp incoming_request(scheme) do
    conn(:get, "/")
    |> put_req_header("x-bbc-edge-scheme", scheme)
    |> put_req_header("x-bbc-edge-host", "www.test.bbc.com")
    |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})
  end

  test "no redirect when x-bbc-edge-host is not a bbc host and x-bbc-edge-scheme is http" do
    conn =
      "http"
      |> incoming_request()
      |> put_req_header("x-bbc-edge-host", "www.notthebbc.com")
      |> HttpRedirector.call([])

    assert conn === HttpRedirector.call(conn, [])
  end

  test "redirect when x-bbc-edge-scheme is http" do
    conn =
      "http"
      |> incoming_request()
      |> HttpRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://" <> conn.host <> "/"]
  end

  test "no redirect when http in uri but https in x-bbc-edge-scheme" do
    conn = incoming_request("https")
    assert conn === HttpRedirector.call(conn, [])
  end

  test "no redirect when uri scheme is https and https in x-bbc-edge-scheme" do
    conn =
      "https"
      |> incoming_request()
      |> put_http_protocol("https")

    assert conn === HttpRedirector.call(conn, [])
  end

  test "will redirect when https in uri but http in x-bbc-edge-scheme" do
    conn =
      "http"
      |> incoming_request()
      |> put_http_protocol("https")
      |> HttpRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://" <> conn.host <> "/"]
  end
end
