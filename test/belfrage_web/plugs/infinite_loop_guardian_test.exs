defmodule BelfrageWeb.Plugs.InfiniteLoopGuardianTest do
  use ExUnit.Case
  import Plug.Test
  alias BelfrageWeb.Plugs.InfiniteLoopGuardian

  test "returns a 404 if req-svc-chain already contains 'BELFRAGE'" do
    conn =
      conn(:get, "/foo/bar/123.json")
      |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART")

    assert %Plug.Conn{status: 404, halted: true} = InfiniteLoopGuardian.call(conn, _opts = [])
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
