defmodule BelfrageWeb.Plugs.VanityDomainRedirectTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.VanityDomainRedirector

  defp make_request(path) do
    conn(:get, path)
    |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})
    |> resp(200, "not being redirected")
    |> VanityDomainRedirector.call([])
  end

  test "redirect when vanity url" do
    conn = make_request("http://www.bbcafaanoromoo.com")

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://www.bbc.com/afaanoromoo"]
  end

  test "no redirect when not vanity url" do
    conn = make_request("http://www.afaanoromoobbc.com")

    assert conn.status == 200
    assert conn.resp_body == "not being redirected"
    assert get_resp_header(conn, "location") == []
  end

  test "redirect when vanity url with path" do
    conn = make_request("http://www.bbcafaanoromoo.com/articles/c841r1v9deko")

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://www.bbc.com/afaanoromoo/articles/c841r1v9deko"]
  end
end
