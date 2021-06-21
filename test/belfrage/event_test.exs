defmodule Belfrage.EventTest do
  use ExUnit.Case
  alias Belfrage.Event

  describe "new/4 (log)" do
    test "builds event struct" do
      msg = %{msg: "a log message", reason: :for_the_tests}

      event = Event.new(:log, :debug, msg)
      assert event.type == {:log, :debug}
      assert event.data == msg
      assert %DateTime{} = event.timestamp
      refute event.request_id
    end

    test "uses passed request_id" do
      event = Event.new(:log, :debug, :msg, request_id: "req-12345")
      assert event.request_id == "req-12345"
    end

    test "uses request_id from logger metadata" do
      Stump.metadata(request_id: "req-6789")
      event = Event.new(:log, :debug, :msg)
      assert event.request_id == "req-6789"
    end
  end

  describe "new/4 (metric)" do
    test "builds event struct" do
      event = Event.new(:metric, :increment, "web.request.200")
      assert event.type == {:metric, :increment}
      assert event.data == {"web.request.200", 1}
      assert %DateTime{} = event.timestamp
      refute event.request_id
    end

    test "uses passed value" do
      event = Event.new(:metric, :increment, "web.request.200", value: 4_000)
      assert event.data == {"web.request.200", 4_000}
    end

    test "uses passed request_id" do
      event = Event.new(:metric, :increment, "some_metric", request_id: "req-12345")
      assert event.request_id == "req-12345"
    end

    test "uses request_id from logger metadata" do
      Stump.metadata(request_id: "req-6789")
      event = Event.new(:metric, :increment, "some_metric")
      assert event.request_id == "req-6789"
    end
  end
end
