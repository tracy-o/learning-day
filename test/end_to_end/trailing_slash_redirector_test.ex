defmodule EndToEndTest.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  test "a succesful redirect if there is a trailing slash" do
    conn = conn(:get, "/200-ok-response///")
    conn = Router.call(conn, [])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"location", "/200-ok-response"} in headers
    assert {"cache-control", "public, max-age=60"} in headers
  end

  test "keeps default response headers" do
    conn = conn(:get, "/200-ok-response///") |> Plug.Conn.put_req_header("req-svc-chain", "GTM")
    conn = Router.call(conn, [])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"server", "Belfrage"} in headers
    assert {"via", "1.1 Belfrage"} in headers
    assert {"vary", "Accept-Encoding, X-BBC-Edge-Cache, X-Country, X-IP_Is_UK_Combined, X-BBC-Edge-Scheme"} in headers
  end

  test "keeps req-svc-chain values when provided" do
    conn = conn(:get, "/200-ok-response///") |> Plug.Conn.put_req_header("req-svc-chain", "GTM")
    conn = Router.call(conn, [])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"req-svc-chain", "GTM,BELFRAGE"} in headers
  end
end
