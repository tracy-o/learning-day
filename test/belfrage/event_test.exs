defmodule Belfrage.EventTest do
  use ExUnit.Case
  alias Belfrage.Event

  describe "new/4 (log)" do
    test "builds event struct" do
      level = :debug
      msg = %{msg: "a log message", reason: :for_the_tests}
      opts = []

      assert %Belfrage.Event{
               request_id: nil,
               data: ^msg,
               timestamp: timestamp,
               type: {:log, :debug}
             } = Event.new(:log, level, msg, opts)

      assert timestamp.__struct__ == DateTime
    end

    test "when request_id is given explicitly" do
      level = :debug
      msg = %{msg: "a log message", reason: :for_the_tests}
      opts = [request_id: "req-12345"]

      assert %Belfrage.Event{
               request_id: "req-12345"
             } = Event.new(:log, level, msg, opts)
    end

    test "when request_id is attached to the process info" do
      Process.put(:request_id, "req-6789")

      level = :debug
      msg = %{msg: "a log message", reason: :for_the_tests}
      opts = []

      assert %Belfrage.Event{
               request_id: "req-6789"
             } = Event.new(:log, level, msg, opts)
    end
  end

  describe "new/4 (metric)" do
    test "builds an event struct" do
      type = :increment
      metric = "web.request.200"
      opts = []

      assert %Belfrage.Event{
               request_id: nil,
               data: {"web.request.200", 1},
               timestamp: timestamp,
               type: {:metric, :increment}
             } = Event.new(:metric, type, metric, opts)

      assert timestamp.__struct__ == DateTime
    end

    test "when value is given" do
      type = :increment
      metric = "web.request.200"
      opts = [value: 4_000]

      assert %Belfrage.Event{
               data: {"web.request.200", 4_000}
             } = Event.new(:metric, type, metric, opts)
    end

    test "when request_id is given explicitly" do
      type = :increment
      metric = "web.request.200"
      opts = [request_id: "req-12345"]

      assert %Belfrage.Event{
               request_id: "req-12345"
             } = Event.new(:metric, type, metric, opts)
    end

    test "when request_id is attached to the process info" do
      Process.put(:request_id, "req-6789")

      type = :increment
      metric = "web.request.200"
      opts = []

      assert %Belfrage.Event{
               request_id: "req-6789"
             } = Event.new(:metric, type, metric, opts)
    end
  end
end