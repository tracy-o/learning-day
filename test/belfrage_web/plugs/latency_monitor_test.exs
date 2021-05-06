defmodule BelfrageWeb.Plugs.LatencyMonitorTest do
  use ExUnit.Case
  import Plug.Test, only: [conn: 2, sent_resp: 1]

  setup do
    {:ok, _pid} = Belfrage.Metrics.LatencyMonitor.start_link()

    :ok
  end

  test "calls LatencyMonitor checkpoints for request_start and response_end for 200s" do
    pid = Process.whereis(Belfrage.Metrics.LatencyMonitor)
    :erlang.trace(pid, true, [:receive])

    conn = conn(:get, "/")
    |> Plug.Conn.put_private(:request_id, "gary-the-get-request")

    conn_next = BelfrageWeb.Plugs.LatencyMonitor.call(conn, _opts = [])
    |> Plug.Conn.send_resp(200, "foo")

    assert_receive {:trace, ^pid, :receive, {
      _,
      {:checkpoint, :request_start, "gary-the-get-request", _time}
    }}

    assert_receive {:trace, ^pid, :receive, {
      _,
      {:checkpoint, :response_end, "gary-the-get-request", _time}
    }}
  end

  test "calls LatencyMonitor discard for non-200s" do
    pid = Process.whereis(Belfrage.Metrics.LatencyMonitor)
    :erlang.trace(pid, true, [:receive])

    conn = conn(:get, "/")
    |> Plug.Conn.put_private(:request_id, "gary-the-get-request")

    conn_next = BelfrageWeb.Plugs.LatencyMonitor.call(conn, _opts = [])
    |> Plug.Conn.send_resp(400, "foo")

    assert_receive {:trace, ^pid, :receive, {
      _,
      {:discard, "gary-the-get-request"}
    }}
  end
end
