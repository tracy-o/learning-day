defmodule BelfrageWeb.Plugs.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.TrailingSlashRedirector

  defp incoming_request(path) do
    conn(:get, path)
    |> resp(200, "not being redirected")
  end

  test "no redirect when top level '/' in path " do
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
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page"]
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
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page"]
  end

  test "redirect when path has trailing slash and query string with no trailing slash" do
    conn =
      incoming_request("/a-page/?a-query")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page?a-query"]
  end

  test "redirect when path has trailing slash and query string also with a trailing slash" do
    conn =
      incoming_request("/a-page/?a-query/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page?a-query/"]
  end
end
