defmodule EndToEndTest.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  setup do
    start_supervised!({RouteState, "SomeRouteState"})
    :ok
  end

  test "redirect preserves multiple slashes if not at beginning or end of path" do
    conn =
      :get
      |> conn("/some//path//with//multiple///forward////slashes///")
      |> Router.call([])

    assert {301, _headers, ""} = sent_resp(conn)
    assert Plug.Conn.get_resp_header(conn, "location") == ["/some//path//with//multiple///forward////slashes"]
  end

  test "a succesful redirect if there  multiple trailing slashes at the top level" do
    conn =
      conn(:get, "///")
      |> Map.put(:request_path, "///")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"location", "/"} in headers
  end

  test "a succesful redirect if there is a trailing slash" do
    conn = conn(:get, "/200-ok-response///")
    conn = Router.call(conn, [])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"location", "/200-ok-response"} in headers
    assert {"cache-control", "public, max-age=60"} in headers
  end

  test "keeps default response headers" do
    conn =
      conn(:get, "/200-ok-response///")
      |> put_req_header("req-svc-chain", "GTM")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"server", "Belfrage"} in headers
    assert {"via", "1.1 Belfrage"} in headers
    assert {"x-bbc-no-scheme-rewrite", "1"} in headers
  end

  test "keeps req-svc-chain values when provided" do
    conn =
      conn(:get, "/200-ok-response///")
      |> put_req_header("req-svc-chain", "GTM")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"req-svc-chain", "GTM,BELFRAGE"} in headers
  end

  test "does not issue open redirects" do
    conn =
      :get
      |> conn("https://example.com//foo.com/")
      |> Router.call([])

    assert {301, _headers, ""} = sent_resp(conn)
    assert Plug.Conn.get_resp_header(conn, "location") == ["/foo.com"]
  end

  test "does not issue open redirects when querystring are present" do
    conn =
      :get
      |> conn("https://example.com//foo.com/?foo=bar&a=b")
      |> Router.call([])

    assert {301, _headers, ""} = sent_resp(conn)
    assert Plug.Conn.get_resp_header(conn, "location") == ["/foo.com?foo=bar&a=b"]
  end
end
