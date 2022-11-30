defmodule BelfrageWeb.Plugs.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.TrailingSlashRedirector

  defp incoming_request(path) do
    conn(:get, path)
    |> Plug.Conn.put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE"})
    |> resp(200, "not being redirected")
  end

  test "no redirect when top level '/' in path" do
    conn =
      incoming_request("/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 200
    assert conn.resp_body == "not being redirected"
    assert get_resp_header(conn, "location") == []
  end

  test "no redirect when no trailing slash on path" do
    conn =
      incoming_request("/a-page")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 200
    assert conn.resp_body == "not being redirected"
    assert get_resp_header(conn, "location") == []
  end

  test "no redirect when no trailing slash on path or query string" do
    conn =
      incoming_request("/a-page?a-query")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 200
    assert conn.resp_body == "not being redirected"
    assert get_resp_header(conn, "location") == []
  end

  test "redirect when root path has trailing slashes" do
    conn =
      incoming_request("/a-page///")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["/a-page"]
  end

  test "no redirect when no trailing slash on path, but a trailing slash on query string" do
    conn =
      incoming_request("/a-page?a-query/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 200
    assert conn.resp_body == "not being redirected"
    assert get_resp_header(conn, "location") == []
  end

  test "redirect when path has trailing slash" do
    conn =
      incoming_request("/a-page/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["/a-page"]
  end

  test "redirect when path has trailing slash and query string with no trailing slash" do
    conn =
      incoming_request("/a-page/?a-query")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["/a-page?a-query"]
  end

  test "redirect when path has trailing slash and query string also with a trailing slash" do
    conn =
      incoming_request("/a-page/?a-query/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["/a-page?a-query/"]
  end

  test "redirect preserves multiple slashes if not at beginning or end of path" do
    conn =
      incoming_request("/some//path//with//multiple///forward////slashes///")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["/some//path//with//multiple///forward////slashes"]
  end

  test "does not issue open redirects" do
    conn =
      incoming_request("https://example.com//foo.com/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["/foo.com"]
  end

  test "does not issue open redirects when querystring are present" do
    conn =
      incoming_request("https://example.com//foo.com/?foo=bar&a=b")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == ""
    assert get_resp_header(conn, "location") == ["/foo.com?foo=bar&a=b"]
  end
end
