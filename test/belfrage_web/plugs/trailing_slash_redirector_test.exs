defmodule BelfrageWeb.Plugs.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.TrailingSlashRedirector

  defp incoming_request(path) do
    conn(:get, path)
    |> put_resp_header("location", "unchanged")
    |> resp(200, "not being redirected")
  end

  test "does not redirect when path doesn't have trailing slash" do
    conn =
      incoming_request("/a-page")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 200
    assert conn.resp_body == "not being redirected"
    assert get_resp_header(conn, "location") == ["unchanged"]
  end

  test "does not redirect when path has a query string without a trailing slash" do
    conn =
      incoming_request("/a-page?a-query")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 200
    assert conn.resp_body == "not being redirected"
    assert get_resp_header(conn, "location") == ["unchanged"]
  end

  test "does redirect when path has a trailing slash" do
    conn =
      incoming_request("/a-page/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page"]
  end

  test "does redirect when path has a query string and a trailing slash" do
    conn =
      incoming_request("/a-page?a-query/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page?a-query"]
  end

  test "does redirect when path has a trailing slash and the query has a trailing slash" do
    conn =
      incoming_request("/a-page/?a-query/")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page?a-query"]
  end

  test "does redirect when path has more than one trailing slash" do
    conn =
      incoming_request("/a-page///")
      |> TrailingSlashRedirector.call([])

    assert conn.status == 301
    assert conn.resp_body == "Redirecting"
    assert get_resp_header(conn, "location") == ["http://www.example.com/a-page"]
  end
end
