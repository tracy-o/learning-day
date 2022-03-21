defmodule BelfrageWeb.Plugs.InfiniteLoopGuardianTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Plugs.InfiniteLoopGuardian

  describe "stack is bruce belfrage" do
    setup do
      set_stack_id("bruce")
      :ok
    end

    test "returns a 404 if req-svc-chain contains 3 instances of 'BELFRAGE'" do
      conn =
        conn(:get, "/foo/bar/123.json")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE,MOZART,BELFRAGE")

      assert %Plug.Conn{status: 404, halted: true, resp_headers: resp_headers} =
               InfiniteLoopGuardian.call(conn, _opts = [])

      assert {"req-svc-chain", "BELFRAGE"} in resp_headers
      assert {"bid", "bruce"} in resp_headers
    end

    test "continues if req-svc-chain contains 2 instances of 'BELFRAGE'" do
      conn =
        conn(:get, "/foo/bar/123.json")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")

      assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
    end
  end

  describe "stack isn't bruce belfrage" do
    setup do
      set_stack_id("not-bruce")
      :ok
    end

    test "returns a 404 if req-svc-chain contains 2 instances of 'BELFRAGE'" do
      conn =
        conn(:get, "/foo/bar/123.json")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")

      assert %Plug.Conn{status: 404, halted: true, resp_headers: resp_headers} =
               InfiniteLoopGuardian.call(conn, _opts = [])

      assert {"req-svc-chain", "BELFRAGE"} in resp_headers
      assert {"bid", "not-bruce"} in resp_headers
    end

    test "continues if req-svc-chain contains 1 instances of 'BELFRAGE'" do
      conn =
        conn(:get, "/foo/bar/123.json")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART")

      assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
    end
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

  def set_stack_id(stack_id) do
    prev_stack_id = Application.get_env(:belfrage, :stack_id)
    Application.put_env(:belfrage, :stack_id, stack_id)

    on_exit(fn -> Application.put_env(:belfrage, :stack_id, prev_stack_id) end)
  end
end
