defmodule Belfrage.MetricsTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.MetricsHelper

  alias Belfrage.Metrics

  describe "measurement/3" do
    test "emits an event with the passed measurements and metadata" do
      assert_metric({:foo, %{bar: 1}, %{baz: 2}}, fn ->
        Metrics.measurement(:foo, %{bar: 1}, %{baz: 2})
      end)
    end
  end

  describe "duration/2" do
    test "emits a stop event with the duration of the passed function" do
      {_, %{duration: duration}, %{}} =
        intercept_metric([:foo, :stop], fn ->
          Metrics.duration(:foo, fn -> Process.sleep(1) end)
        end)

      assert duration > 0
    end
  end

  describe "duration/3" do
    test "emits a stop event with the duration of the passed function and metadata" do
      {_, %{duration: duration}, %{bar: :baz}} =
        intercept_metric([:foo, :stop], fn ->
          Metrics.duration(:foo, %{bar: :baz}, fn -> Process.sleep(1) end)
        end)

      assert duration > 0
    end
  end

  describe "event/2" do
    test "emits an event with no measurements and no metadata" do
      assert_metric({[:foo, :bar], %{}, %{}}, fn ->
        Metrics.event([:foo, :bar])
      end)
    end

    test "emits an event with metadata" do
      assert_metric({[:foo], %{}, %{bar: 1}}, fn ->
        Metrics.event(:foo, %{bar: 1})
      end)
    end
  end

  describe "stop/3" do
    test "emits a stop event with duration measurement and metadata" do
      start_time = System.monotonic_time() - 1

      {_, %{duration: duration}, %{bar: :baz}} =
        intercept_metric([:foo, :stop], fn ->
          Metrics.stop(:foo, start_time, %{bar: :baz})
        end)

      assert duration > 0
    end

    test "emits a stop event with duration, start_time and metadata" do
      start_time = System.monotonic_time() - 1

      {_, %{start_time: _start_time, duration: duration}, %{bar: :baz}} =
        intercept_metric([:foo, :stop], fn ->
          Metrics.stop(:foo, start_time, %{bar: :baz})
        end)

      assert duration > 0
    end
  end

  test "multi_span emits start and stop events" do
    id = :test_multi_span
    pid = self()

    :telemetry.attach_many(
      id,
      [
        [:a, :start],
        [:a, :stop],
        [:b, :start],
        [:b, :stop]
      ],
      fn event_name, measurements, _metadata, _config ->
        send(pid, {event_name, measurements})
      end,
      %{}
    )

    Belfrage.Metrics.multi_span([[:a], [:b]], %{}, fn -> {nil, %{}} end)
    :telemetry.detach(id)

    assert_receive {[:a, :start], %{}}
    assert_receive {[:b, :start], %{}}
    assert_receive {[:a, :stop], %{duration: _}}
    assert_receive {[:b, :stop], %{duration: _}}
  end

  test "multi_span emits start and exception events" do
    id = :test_multi_span_exception
    pid = self()

    :telemetry.attach_many(
      id,
      [
        [:a, :start],
        [:a, :exception],
        [:b, :start],
        [:b, :exception]
      ],
      fn event_name, measurements, _metadata, _config ->
        send(pid, {event_name, measurements})
      end,
      %{}
    )

    try do
      Belfrage.Metrics.multi_span([[:a], [:b]], %{}, fn -> raise "oops" end)
    rescue
      _ -> nil
    else
      _ -> :telemetry.detach(id)
    end

    assert_receive {[:a, :start], %{}}
    assert_receive {[:b, :start], %{}}
    assert_receive {[:a, :exception], %{duration: _}}
    assert_receive {[:b, :exception], %{duration: _}}
  end
end
