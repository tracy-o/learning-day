defmodule Belfrage.EventTest do
  use ExUnit.Case
  alias Belfrage.Event

  describe "build_log_event/3" do
    test "builds event struct" do
      level = :debug
      msg = %{msg: "a log message", reason: :for_the_tests}
      opts = []

      assert %Belfrage.Event{
               req_id: nil,
               data: ^msg,
               timestamp: timestamp,
               type: {:log, :debug}
             } = Event.build_log_event(level, msg, opts)

      assert timestamp.__struct__ == DateTime
    end

    test "when req_id is given explicitly" do
      level = :debug
      msg = %{msg: "a log message", reason: :for_the_tests}
      opts = [req_id: "req-12345"]

      assert %Belfrage.Event{
               req_id: "req-12345"
             } = Event.build_log_event(level, msg, opts)
    end

    test "when req_id is attached to the process info" do
      Process.put(:req_id, "req-6789")

      level = :debug
      msg = %{msg: "a log message", reason: :for_the_tests}
      opts = []

      assert %Belfrage.Event{
               req_id: "req-6789"
             } = Event.build_log_event(level, msg, opts)
    end
  end

  describe "build_metric_event/3" do
    test "builds an event struct" do
      type = :increment
      metric = "web.request.200"
      opts = []

      assert %Belfrage.Event{
               req_id: nil,
               data: {"web.request.200", 1},
               timestamp: timestamp,
               type: {:metric, :increment}
             } = Event.build_metric_event(type, metric, opts)

      assert timestamp.__struct__ == DateTime
    end

    test "when value is given" do
      type = :increment
      metric = "web.request.200"
      opts = [value: 4_000]

      assert %Belfrage.Event{
               data: {"web.request.200", 4_000}
             } = Event.build_metric_event(type, metric, opts)
    end

    test "when req_id is given explicitly" do
      type = :increment
      metric = "web.request.200"
      opts = [req_id: "req-12345"]

      assert %Belfrage.Event{
               req_id: "req-12345"
             } = Event.build_metric_event(type, metric, opts)
    end

    test "when req_id is attached to the process info" do
      Process.put(:req_id, "req-6789")

      type = :increment
      metric = "web.request.200"
      opts = []

      assert %Belfrage.Event{
               req_id: "req-6789"
             } = Event.build_metric_event(type, metric, opts)
    end
  end
end
