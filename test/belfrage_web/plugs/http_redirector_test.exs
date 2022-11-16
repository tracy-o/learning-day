defmodule BelfrageWeb.Plugs.HttpRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.HttpRedirector

  defp incoming_request(scheme) do
    conn(:get, "/")
    |> put_req_header("x-bbc-edge-scheme", scheme)
    |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})
    |> resp(200, "")
  end

  test "redirect when protocol is insecure" do
    conn =
      incoming_request("http")
      |> HttpRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://" <> conn.host <> "/"]
  end

  test "no redirect when scheme is secure" do
    conn =
      incoming_request("https")
      |> HttpRedirector.call([])

    assert conn.status == 200
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == []
  end
end
