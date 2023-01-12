defmodule BelfrageWeb.Plugs.VanityDomainRedirectTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.VanityDomainRedirector

  defp incoming_request(path) do
    conn(:get, path)
    |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})
    |> resp(200, "not being redirected")
  end

  test "redirect when vanity url and scheme is http" do
    conn =
      incoming_request("http://www.bbcafaanoromoo.com")
      |> VanityDomainRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://www.bbc.com/afaanoromoo"]
  end

  test "redirect when vanity url and scheme is https" do
    conn =
      incoming_request("https://www.bbcafaanoromoo.com")
      |> VanityDomainRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://www.bbc.com/afaanoromoo"]
  end

  test "redirect when not vanity url" do
    conn = incoming_request("http://www.afaanoromoobbc.com")

    assert conn.status == 200
    assert get_resp_header(conn, "location") == []
  end

  test "redirect when vanity url with path and scheme is http" do
    conn =
      incoming_request("http://www.bbcafaanoromoo.com/articles/c841r1v9deko")
      |> VanityDomainRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://www.bbc.com/afaanoromoo/articles/c841r1v9deko"]
  end

  test "redirect when vanity url with path and scheme is https" do
    conn =
      incoming_request("https://www.bbcafaanoromoo.com/articles/c841r1v9deko")
      |> VanityDomainRedirector.call([])

    assert conn.status == 302
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["https://www.bbc.com/afaanoromoo/articles/c841r1v9deko"]
  end
end
