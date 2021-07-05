defmodule BelfrageWeb.Plugs.LatencyMonitorTest do
  use ExUnit.Case
  import Plug.Test, only: [conn: 2]

  setup do
    {:ok, _pid} = Belfrage.Metrics.LatencyMonitor.start_link()

    :ok
  end

  test "calls LatencyMonitor checkpoints for request_received and response_sent for 200s" do
    pid = Process.whereis(Belfrage.Metrics.LatencyMonitor)
    :erlang.trace(pid, true, [:receive])

    conn(:get, "/")
    |> Plug.Conn.put_private(:request_id, "gary-the-get-request")
    |> BelfrageWeb.Plugs.LatencyMonitor.call(_opts = [])
    |> Plug.Conn.send_resp(200, "foo")

    assert_receive {:trace, ^pid, :receive,
                    {
                      _,
                      {:checkpoint, :request_received, "gary-the-get-request", _time}
                    }}

    assert_receive {:trace, ^pid, :receive,
                    {
                      _,
                      {:checkpoint, :response_sent, "gary-the-get-request", _time}
                    }}
  end

  test "calls LatencyMonitor discard for non-200s" do
    pid = Process.whereis(Belfrage.Metrics.LatencyMonitor)
    :erlang.trace(pid, true, [:receive])

    conn(:get, "/")
    |> Plug.Conn.put_private(:request_id, "gary-the-get-request")
    |> BelfrageWeb.Plugs.LatencyMonitor.call(_opts = [])
    |> Plug.Conn.send_resp(400, "foo")

    assert_receive {:trace, ^pid, :receive,
                    {
                      _,
                      {:discard, "gary-the-get-request"}
                    }}
  end
end
