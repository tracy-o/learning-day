defmodule BelfrageWeb.Plugs.InfiniteLoopGuardianTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Plugs.InfiniteLoopGuardian

  test "returns a 404 if req-svc-chain already contains 'BELFRAGE'" do
    not_found_page = Application.get_env(:belfrage, :not_found_page)

    Belfrage.Helpers.FileIOMock
    |> expect(:read, fn ^not_found_page -> {:ok, "<h1>404 Error Page</h1>\n"} end)

    conn =
      conn(:get, "/foo/bar/123.json")
      |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART")

    assert %Plug.Conn{
             status: 404,
             halted: true,
             resp_headers: [
               {"cache-control", "public, stale-if-error=90, stale-while-revalidate=60, max-age=30"},
               {"content-type", "text/html; charset=utf-8"},
               {"vary", "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"},
               {"server", "Belfrage"},
               {"bid", "local"},
               {"via", "1.1 Belfrage"},
               {"req-svc-chain", "BELFRAGE"},
               {"belfrage-cache-status", "MISS"}
             ]
           } = InfiniteLoopGuardian.call(conn, _opts = [])
  end

  test "continues if there is no req-svc-chain header" do
    conn = conn(:get, "/foo/bar/123.json")

    assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
  end

  test "continues if req-svc-chain does not contain 'BELFRAGE'" do
    conn =
      conn(:get, "/foo/bar/123.json")
      |> Plug.Conn.put_req_header("req-svc-chain", "GTM,MOZART")

    assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
  end
end
