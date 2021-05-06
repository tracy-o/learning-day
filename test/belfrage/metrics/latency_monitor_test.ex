defmodule Belfrage.Metrics.LatencyMonitorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Metrics.LatencyMonitor
  alias Belfrage.TestGenServer

  setup :set_mox_global
  setup :verify_on_exit!

  setup do
    {:ok, pid} = LatencyMonitor.start_link({})
    :ok
  end

  describe "checkpoint/2" do
    test "casts a checkpoint message to the genserver" do
      request_id = "some-request-id"
      ref = make_ref()

      assert :ok == LatencyMonitor.checkpoint(request_id, :request_start, ref)
      assert %{^request_id => %{request_start: ref}} = :sys.get_state(LatencyMonitor)
    end
  end

  describe "discard/2" do
    test "casts a discard message to the genserver" do
      request_id = "some-other-request-id"

      assert :ok == LatencyMonitor.checkpoint(request_id, :request_start, 1234)
      assert %{^request_id => _} = :sys.get_state(LatencyMonitor)

      assert :ok == LatencyMonitor.discard(request_id)
      assert %{} = :sys.get_state(LatencyMonitor)
    end

    test ":cleanup scheduled" do
      # TODO assert that cleanup runs regularly
    end
  end

  describe "handle_info/2" do
    test "should handle undefined messages transparently" do
      input_state = %{"a-bit-of-a-state" => %{request_start: 1234}}
      assert {:noreply, input_state} == LatencyMonitor.handle_info(:an_undefined_message, input_state)
    end
  end

  describe "handle_info/2 :cleanup" do
    test "should remove any request_ids which are older than the TTL" do
      now = System.monotonic_time(:nanosecond) / 1_000_000

      input_state = %{
        "oliver-the-older" => %{request_start: now - 31_000},
        "nelly-the-newer" => %{request_start: now - 29_000}
      }

      expected_state = %{
        "nelly-the-newer" => %{request_start: now - 29_000}
      }

      assert {:noreply, expected_state} == LatencyMonitor.handle_info(:cleanup, input_state)
    end
  end

  describe "handle_cast/2 :checkpoint" do
    test "should create new entry in state for a new request's first checkpoint" do
      input_state = %{
        "evan-the-existing" => %{request_start: 123}
      }

      expected_state = %{
        "evan-the-existing" => %{request_start: 123},
        "adam-the-addition" => %{request_start: 456}
      }

      assert {:noreply, expected_state} ==
               LatencyMonitor.handle_cast({:checkpoint, :request_start, "adam-the-addition", 456}, input_state)
    end

    test "should update state to reflect a valid checkpoints" do
      input_state = %{
        "isaac-the-incomplete" => %{request_start: 123}
      }

      expected_state_1 = %{
        "isaac-the-incomplete" => %{request_start: 123, request_end: 234}
      }

      expected_state_2 = %{
        "isaac-the-incomplete" => %{request_start: 123, request_end: 234, response_start: 345}
      }

      assert {:noreply, expected_state_1} ==
               LatencyMonitor.handle_cast({:checkpoint, :request_end, "isaac-the-incomplete", 234}, input_state)

      assert {:noreply, expected_state_2} ==
               LatencyMonitor.handle_cast({:checkpoint, :response_start, "isaac-the-incomplete", 345}, expected_state_1)
    end

    test "should not update state to reflect an invalid checkpoint" do
      input_state = %{
        "ursula-the-unchanged" => %{request_start: 123}
      }

      catch_error(
        LatencyMonitor.handle_cast({:checkpoint, :party_time_start, "ursula-the-unchanged", 234}, input_state)
      )
    end

    test "should send metrics upon recieving the :response_end checkpoint for a complete a set of times" do
      parent = self()
      ref = make_ref()
      input_state = %{
        "sam-the-sendable" => %{request_start: 123, request_end: 234, response_start: 345}
      }

      ExMetrics.Statsd.StatixConnectionMock
      |> expect(:timing, 3, fn
        "web.latency.internal.request", val, _ -> send(parent, {ref, :request})
        "web.latency.internal.response", val, _ -> send(parent, {ref, :response})
        "web.latency.internal.combined", val, _  -> send(parent, {ref, :combined})
      end)


      assert {:noreply, %{}} ==
               LatencyMonitor.handle_cast({:checkpoint, :response_end, "sam-the-sendable", 234}, input_state)

      Process.sleep(100)

      assert_received {^ref, :request}
      assert_received {^ref, :response}
      assert_received {^ref, :combined}
    end

    test "should not send metrics upon recieving the :response_end checkpoint for an incomplete set of times" do
      parent = self()
      ref = make_ref()
      input_state = %{
        "iris-the-incomplete" => %{request_start: 123, request_end: 234}
      }

      ExMetrics.Statsd.StatixConnectionMock
      |> expect(:timing, 0, fn
        "web.latency.internal.request", val, _ -> send(parent, {ref, :request})
        "web.latency.internal.response", val, _ -> send(parent, {ref, :response})
        "web.latency.internal.combined", val, _  -> send(parent, {ref, :combined})
      end)

      assert {:noreply, %{}} ==
               LatencyMonitor.handle_cast({:checkpoint, :response_end, "iris-the-incomplete", 234}, input_state)

      Process.sleep(100)

      refute_received {^ref, :request}
      refute_received {^ref, :response}
      refute_received {^ref, :combined}
    end
  end

  describe "handle_cast/2 :discard" do
    test "should update state remove discarded request_id" do
      input_state = %{
        "dave-the-deleted" => %{request_start: 123},
        "pete-the-persisted" => %{request_start: 456}
      }

      expected_state = %{
        "pete-the-persisted" => %{request_start: 456}
      }

      assert {:noreply, expected_state} == LatencyMonitor.handle_cast({:discard, "dave-the-deleted"}, input_state)
    end
  end
end
