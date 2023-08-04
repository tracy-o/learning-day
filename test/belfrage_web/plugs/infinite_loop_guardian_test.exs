defmodule BelfrageWeb.Plugs.InfiniteLoopGuardianTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox
  import ExUnit.CaptureLog
  import Belfrage.Test.MetricsHelper

  alias BelfrageWeb.Plugs.InfiniteLoopGuardian
  import Test.Support.Helper, only: [set_stack_id: 1]

  describe "stack is bruce belfrage" do
    setup do
      set_stack_id("bruce")
      :ok
    end

    test "returns a 404 if req-svc-chain contains 2 instances of 'BELFRAGE' and the route starts with /news" do
      conn =
        conn(:get, "/news")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")

      assert %Plug.Conn{status: 404, halted: true, resp_headers: resp_headers} =
               InfiniteLoopGuardian.call(conn, _opts = [])

      assert {"req-svc-chain", "BELFRAGE"} in resp_headers
      assert {"bid", "bruce"} in resp_headers
    end

    test "logs an error if req-svc-chain contains 2 instances of 'BELFRAGE' and the route starts with /news" do
      conn =
        conn(:get, "/news")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")

      assert capture_log([level: :error], fn -> InfiniteLoopGuardian.call(conn, _opts = []) end) =~
               "Returned a 404 as infinite Belfrage/Mozart loop detected"

      assert capture_log([level: :warn], fn -> InfiniteLoopGuardian.call(conn, _opts = []) end) =~
               "Returned a 404 as infinite Belfrage/Mozart loop detected"
    end

    test "sends an event if req-svc-chain contains 2 instances of 'BELFRAGE' and the route starts with /news" do
      conn =
        conn(:get, "/news")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")

      assert_metric([:request, :infinite_loop], fn -> InfiniteLoopGuardian.call(conn, _opts = []) end)
    end

    test "sends a metric if req-svc-chain contains 2 instances of 'BELFRAGE' and the route starts with /news" do
      {socket, port} = given_udp_port_opened()

      start_reporter(
        metrics: Belfrage.Metrics.Statsd.statix_static_metrics(),
        formatter: :datadog,
        global_tags: [BBCEnvironment: "live"],
        port: port
      )

      :get
      |> conn("/news")
      |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")
      |> InfiniteLoopGuardian.call(_opts = [])

      assert_reported(
        socket,
        "belfrage.request.infinite_loop:1|c|#BBCEnvironment:live"
      )
    end

    test "returns a 404 if req-svc-chain contains 2 instances of 'BELFRAGE' and the route starts with //news" do
      # This must include the hostname because with // it thinks the host is following
      conn =
        conn(:get, "http://www.example.com//news")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")

      assert %Plug.Conn{status: 404, halted: true, resp_headers: resp_headers} =
               InfiniteLoopGuardian.call(conn, _opts = [])

      assert {"req-svc-chain", "BELFRAGE"} in resp_headers
      assert {"bid", "bruce"} in resp_headers
    end

    test "returns a 404 if req-svc-chain contains 2 instances of 'BELFRAGE' and the route starts with /news%2F" do
      conn =
        conn(:get, "/news%2F")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")

      assert %Plug.Conn{status: 404, halted: true, resp_headers: resp_headers} =
               InfiniteLoopGuardian.call(conn, _opts = [])

      assert {"req-svc-chain", "BELFRAGE"} in resp_headers
      assert {"bid", "bruce"} in resp_headers
    end

    test "continues if req-svc-chain contains 1 instances of 'BELFRAGE'" do
      conn =
        conn(:get, "/news")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART")

      assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
    end
  end

  describe "stack isn't bruce belfrage" do
    setup do
      set_stack_id("not-bruce")
      :ok
    end

    test "returns a 404 if req-svc-chain contains 1 instances of 'BELFRAGE'" do
      conn =
        conn(:get, "/news")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART")

      assert %Plug.Conn{status: 404, halted: true, resp_headers: resp_headers} =
               InfiniteLoopGuardian.call(conn, _opts = [])

      assert {"req-svc-chain", "BELFRAGE"} in resp_headers
      assert {"bid", "not-bruce"} in resp_headers
    end

    test "continues if req-svc-chain contains 0 instances of 'BELFRAGE'" do
      conn =
        conn(:get, "/news")
        |> Plug.Conn.put_req_header("req-svc-chain", "GTM,MOZART")

      assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
    end
  end

  test "checks routes which match '/news' or '/news/*'" do
    # Test is set up so that if the route matches, an infinite loop is detected

    routes = [
      "/news",
      "/news/something/1234"
    ]

    for route <- routes do
      conn =
        conn(:get, route)
        |> Plug.Conn.put_req_header("req-svc-chain", "BELFRAGE")

      assert %Plug.Conn{status: 404, halted: true} = InfiniteLoopGuardian.call(conn, [])
    end
  end

  test "continues if there is no req-svc-chain header" do
    conn = conn(:get, "/news")

    assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
  end

  test "continues if req-svc-chain does not contain 'BELFRAGE'" do
    conn =
      conn(:get, "/news")
      |> Plug.Conn.put_req_header("req-svc-chain", "GTM,MOZART")

    assert %Plug.Conn{status: nil, halted: false} = InfiniteLoopGuardian.call(conn, _opts = [])
  end
end
