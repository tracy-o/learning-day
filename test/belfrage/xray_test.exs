defmodule Belfrage.XrayTest do
  use ExUnit.Case, async: true

  alias Belfrage.Xray
  import ExUnit.CaptureLog

  @segment %AwsExRay.Segment{
    trace: %AwsExRay.Trace{
      parent: "",
      root: "1-5dd274e2-00644696c03ec16a784a2e43",
      sampled: false
    },
    id: "fake-xray-parent-id"
  }

  defmodule AwsExRayMockError do
    def finish_tracing(_segment) do
      raise "error when finishing tracing"
    end

    def finish_subsegment(_segment) do
      raise "error when finishing subsegment"
    end
  end

  defmodule AwsExRayMockExit do
    def start_tracing(_name) do
      exit(:start_tracing)
    end

    def finish_tracing(_segment) do
      exit(:finish_tracing)
    end

    def start_subsegment(_name) do
      exit(:start_subsegment)
    end

    def finish_subsegment(_segment) do
      exit(:finish_subsegment)
    end
  end

  describe "start_tracing/1 on success" do
    test "returns {:ok, trace}" do
      assert {:ok, _trace} = Xray.start_tracing("Belfrage")
    end
  end

  describe "start_tracing/1 on error" do
    test "when catches :error, returns {:error, reason}" do
      # cannot start same trace twice, causes an error
      Xray.start_tracing("Belfrage")
      {:error, msg} = Xray.start_tracing("Belfrage")

      assert msg =~ "AwsExRay.start_tracing/1 errored with reason: "
      assert msg =~ "<AwsExRay> Tracing Context already exists on this process."
    end

    test "when catches :error, logs error" do
      Xray.start_tracing("Belfrage")
      log = capture_log(fn -> Xray.start_tracing("Belfrage") end)

      assert log =~ "AwsExRay.start_tracing/1 errored with reason: "
      assert log =~ "<AwsExRay> Tracing Context already exists on this process."
    end

    test "when catches :exit, returns {:error, reason}" do
      {:error, msg} = Xray.start_tracing("Belfrage", AwsExRayMockExit)
      assert msg == "AwsExRay.start_tracing/1 exited with reason: :start_tracing"
    end

    test "when catches :exit, logs error" do
      log = capture_log(fn -> Xray.start_tracing("Belfrage", AwsExRayMockExit) end)
      assert log =~ "AwsExRay.start_tracing/1 exited with reason: :start_tracing"
    end
  end

  describe "finish_tracing/1 on success" do
    test "return :ok" do
      assert :ok == Xray.finish_tracing(@segment)
    end
  end

  describe "finish_tracing/1 on error" do
    test "when catches :error, returns :ok" do
      assert :ok == Xray.finish_tracing(@segment, AwsExRayMockError)
    end

    test "when catches :error, logs error" do
      log = capture_log(fn -> Xray.finish_tracing(@segment, AwsExRayMockError) end)
      assert log =~ "AwsExRay.finish_tracing/1 errored with reason: "
    end

    test "when catches :exit, returns :ok" do
      assert :ok == Xray.finish_tracing(@segment, AwsExRayMockExit)
    end

    test "when catches :exit, logs error" do
      log = capture_log(fn -> Xray.finish_tracing(@segment, AwsExRayMockExit) end)
      assert log =~ "AwsExRay.finish_tracing/1 exited with reason: :finish_tracing"
    end
  end

  describe "start_subsegment/1 on success" do
    setup do
      Xray.start_tracing("Belfrage")
      :ok
    end

    test "return :ok" do
      assert {:ok, _segment} = Xray.start_subsegment("test_segment")
    end
  end

  describe "start_subsegment/1 on error" do
    test "when catches :error, returns {:error, reason}" do
      # cant start subsegment if trace not started, causes {:error, :out_of_xray}
      {:error, msg} = Xray.start_subsegment("test_segment")
      assert msg =~ "AwsExRay.start_subsegment/1 errored with reason: {:badmatch, {:error, :out_of_xray}}"
    end

    test "when catches :error, logs error" do
      log = capture_log(fn -> Xray.start_subsegment("test_segment") end)
      assert log =~ "AwsExRay.start_subsegment/1 errored with reason: {:badmatch, {:error, :out_of_xray}}"
    end

    test "when catches :exit, returns {:error, reason}" do
      {:error, msg} = Xray.start_subsegment("test_segment", AwsExRayMockExit)
      assert msg == "AwsExRay.start_subsegment/1 exited with reason: :start_subsegment"
    end

    test "when catches :exit, logs error" do
      log = capture_log(fn -> Xray.start_subsegment("test_segment", AwsExRayMockExit) end)
      assert log =~ "AwsExRay.start_subsegment/1 exited with reason: :start_subsegment"
    end
  end

  describe "finish_subsegment/1 on success" do
    test "return :ok" do
      assert :ok == Xray.finish_subsegment(@segment)
    end
  end

  describe "finish_subsegment/1 on error" do
    test "when catches :error, returns :ok" do
      assert :ok == Xray.finish_subsegment(@segment, AwsExRayMockError)
    end

    test "when catches :error, logs error" do
      log = capture_log(fn -> Xray.finish_subsegment(@segment, AwsExRayMockError) end)
      assert log =~ "AwsExRay.finish_subsegment/1 errored with reason: "
    end

    test "when catches :exit, returns :ok" do
      assert :ok == Xray.finish_subsegment(@segment, AwsExRayMockExit)
    end

    test "when catches :exit, logs error" do
      log = capture_log(fn -> Xray.finish_subsegment(@segment, AwsExRayMockExit) end)
      assert log =~ "AwsExRay.finish_subsegment/1 exited with reason: :finish_subsegment"
    end
  end
end
