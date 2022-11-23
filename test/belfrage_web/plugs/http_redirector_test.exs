defmodule BelfrageWeb.Plugs.HttpRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.HttpRedirector

  defp incoming_request(scheme) do
    conn(:get, "/")
    |> put_req_header("x-bbc-edge-scheme", scheme)
    |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})
  end

  test "redirect when protocol is insecure" do
    conn =
      incoming_request("http")
      |> HttpRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://" <> conn.host <> "/"]
  end

  test "no redirect when http in uri but https in edge-scheme" do
    conn =
      conn(:get, "/")
      |> put_http_protocol("http")
      |> put_req_header("x-bbc-edge-scheme", "https")
      |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})

    assert conn === HttpRedirector.call(conn, [])
  end

  test "no redirect when scheme is secure" do
    conn = incoming_request("https")
    assert conn === HttpRedirector.call(conn, [])
  end
end
