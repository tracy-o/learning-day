defmodule BelfrageWeb.Plugs.HttpRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.HttpRedirector

  defp incoming_request(scheme) do
    conn(:get, "/")
    |> put_http_protocol(scheme)
    |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})
    |> resp(200, "not being redirected")
  end

  test "redirect when protocol is insecure" do
    conn =
      incoming_request(:http)
      |> HttpRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["https://" <> conn.host <> "/"]
  end

  test "no redirect when scheme is secure" do
    conn =
      incoming_request(:https)
      |> HttpRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["https://" <> conn.host <> "/"]
  end
end
