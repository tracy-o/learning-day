defmodule Belfrage.Metrics.LatencyMonitorTest do
  use ExUnit.Case
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Metrics.LatencyMonitor

  describe "checkpoint/2" do
    setup do
      start_supervised!(LatencyMonitor)
      :ok
    end

    test "stores a checkpoint for the passed request id" do
      request_id = "some-request-id"
      refute LatencyMonitor.get_checkpoints(request_id)

      time = System.monotonic_time()
      assert LatencyMonitor.checkpoint(request_id, :request_received, time) == :ok
      assert LatencyMonitor.get_checkpoints(request_id) == %{request_received: time}
    end

    test "adds a checkpoint for the passed request id" do
      request_id = "some-request-id"

      assert LatencyMonitor.checkpoint(request_id, :request_received) == :ok
      assert LatencyMonitor.checkpoint(request_id, :origin_request_sent) == :ok

      checkpoints = LatencyMonitor.get_checkpoints(request_id)
      assert checkpoints[:request_received]
      assert checkpoints[:origin_request_sent]
      assert checkpoints[:origin_request_sent] > checkpoints[:request_received]
    end

    test "sends latency metrics on recording :response_sent checkpoint" do
      request_id = "some-request-id"
      now = System.monotonic_time(:millisecond)

      metrics = start_metrics_server()

      LatencyMonitor.checkpoint(request_id, :request_received, now)
      LatencyMonitor.checkpoint(request_id, :origin_request_sent, now + 1_000)
      LatencyMonitor.checkpoint(request_id, :origin_response_received, now + 10_000)
      LatencyMonitor.checkpoint(request_id, :response_sent, now + 12_000)

      refute LatencyMonitor.get_checkpoints(request_id)

      assert sent_metric(metrics) == "web.latency.internal.request:1000|ms"
      assert sent_metric(metrics) == "web.latency.internal.response:2000|ms"
      assert sent_metric(metrics) == "web.latency.internal.combined:3000|ms"
    end

    test "sends latency metrics for early responses" do
      request_id = "some-request-id"
      now = System.monotonic_time(:millisecond)

      metrics = start_metrics_server()

      LatencyMonitor.checkpoint(request_id, :request_received, now)
      LatencyMonitor.checkpoint(request_id, :early_response_received, now + 1_000)
      LatencyMonitor.checkpoint(request_id, :response_sent, now + 3_000)

      refute LatencyMonitor.get_checkpoints(request_id)

      assert sent_metric(metrics) == "web.latency.internal.request:1000|ms"
      assert sent_metric(metrics) == "web.latency.internal.response:2000|ms"
      assert sent_metric(metrics) == "web.latency.internal.combined:3000|ms"
    end

    test "sends latency metrics for fallbacks" do
      request_id = "some-request-id"
      now = System.monotonic_time(:millisecond)

      metrics = start_metrics_server()

      LatencyMonitor.checkpoint(request_id, :request_received, now)
      LatencyMonitor.checkpoint(request_id, :origin_request_sent, now + 1_000)
      LatencyMonitor.checkpoint(request_id, :origin_response_received, now + 10_000)
      LatencyMonitor.checkpoint(request_id, :fallback_request_sent, now + 11_000)
      LatencyMonitor.checkpoint(request_id, :fallback_response_received, now + 13_000)
      LatencyMonitor.checkpoint(request_id, :response_sent, now + 14_000)

      refute LatencyMonitor.get_checkpoints(request_id)

      assert sent_metric(metrics) == "web.latency.internal.request:1000|ms"
      assert sent_metric(metrics) == "web.latency.internal.response:2000|ms"
      assert sent_metric(metrics) == "web.latency.internal.combined:3000|ms"
    end

    test "does not crash on receiving incomplete set of checkpoints" do
      metrics = start_metrics_server()

      LatencyMonitor.checkpoint("request-1", :request_received)

      LatencyMonitor.checkpoint("request-2", :request_received)
      LatencyMonitor.checkpoint("request-2", :response_sent)

      refute LatencyMonitor.get_checkpoints("request-2")
      refute_sent_metrics(metrics)

      assert LatencyMonitor.get_checkpoints("request-1")
    end

    test "does not crash on recording :response_sent checkpoint for a cleaned-up request" do
      LatencyMonitor.checkpoint("request-1", :request_received)
      LatencyMonitor.checkpoint("request-2", :response_sent)

      refute LatencyMonitor.get_checkpoints("request-2")
      assert LatencyMonitor.get_checkpoints("request-1")
    end
  end

  describe "discard/2" do
    setup do
      start_supervised!(LatencyMonitor)
      :ok
    end

    test "removes request checkpoints" do
      request_id = "some-other-request-id"

      assert LatencyMonitor.checkpoint(request_id, :request_received)
      assert %{request_received: _} = LatencyMonitor.get_checkpoints(request_id)

      assert LatencyMonitor.discard(request_id) == :ok
      refute LatencyMonitor.get_checkpoints(request_id)
    end
  end

  describe "auto-cleanup" do
    setup do
      start_supervised!({LatencyMonitor, cleanup_rate: 0})
      :ok
    end

    test "automatically removes old requests" do
      now = System.monotonic_time(:millisecond)

      LatencyMonitor.checkpoint("request-1", :request_received, now - 31_000)
      LatencyMonitor.checkpoint("request-2", :request_received, now - 29_000)

      wait_for(fn -> LatencyMonitor.get_checkpoints("request-1") |> is_nil() end)
      assert LatencyMonitor.get_checkpoints("request-2")

      LatencyMonitor.checkpoint("request-1", :request_received, now - 31_000)

      wait_for(fn -> LatencyMonitor.get_checkpoints("request-1") |> is_nil() end)
      assert LatencyMonitor.get_checkpoints("request-2")
    end

    test "removes requests without request_received timestamp" do
      LatencyMonitor.checkpoint("request", :origin_request_sent, System.monotonic_time(:millisecond))
      wait_for(fn -> LatencyMonitor.get_checkpoints("request") |> is_nil() end)
    end
  end

  defp start_metrics_server() do
    {:ok, server} = :gen_udp.open(8125, active: true)
    on_exit(fn -> :gen_udp.close(server) end)
    server
  end

  defp sent_metric(metrics_server) do
    assert_receive {:udp, ^metrics_server, _ip, _port, message}, 10
    to_string(message)
  end

  defp refute_sent_metrics(metrics_server) do
    refute_receive {:udp, ^metrics_server, _ip, _port, _message}, 10
  end
end
