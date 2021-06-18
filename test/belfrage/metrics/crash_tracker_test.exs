defmodule Belfrage.Metrics.CrashTrackerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  require Logger

  alias Belfrage.Metrics.CrashTracker
  alias Belfrage.EventMock

  defmodule TestCrashingServer do
    use GenServer

    def start_link(_opts \\ []) do
      GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    end

    def crash(reason) do
      GenServer.call(__MODULE__, {:crash, reason})
    end

    @impl true
    def init(_opts), do: {:ok, nil}

    @impl true
    def handle_call({:crash, reason}, _from, _state) do
      case reason do
        :exception ->
          raise "Bang"

        :exit ->
          exit(:bang)

        :throw ->
          throw(:bang)
      end
    end
  end

  setup do
    start_supervised!(TestCrashingServer)
    :ok
  end

  test "tracks process crash caused by an exception" do
    with_tracker(fn ->
      expect_metric()
      cause_crash(:exception)
    end)
  end

  test "tracks abnormal process exits" do
    with_tracker(fn ->
      expect_metric()
      cause_crash(:exit)
    end)
  end

  test "tracks uncaught throws" do
    with_tracker(fn ->
      expect_metric()
      cause_crash(:throw)
    end)
  end

  test "ignores normal exits" do
    with_tracker(fn ->
      expect_no_metric()
      TestCrashingServer |> Process.whereis() |> Process.exit(:normal)
    end)
  end

  test "ignores other errors" do
    with_tracker(fn ->
      expect_no_metric()
      Logger.error("Test error")
    end)
  end

  defp with_tracker(fun) do
    {:ok, tracker_pid} = Logger.add_backend(CrashTracker, flush: true)

    # Monitor the tracker to be notified about its termination
    mref = Process.monitor(tracker_pid)

    fun.()

    # Make sure the tracker processes messages
    Logger.flush()
    Logger.remove_backend(CrashTracker)

    # Fail the test if the tracker terminated abnormally
    receive do
      {:DOWN, ^mref, :process, ^tracker_pid, {:EXIT, exit}} ->
        flunk(Exception.format_exit(exit))
    after
      0 -> nil
    end
  end

  defp expect_metric() do
    expect(EventMock, :record, fn type, operation, metric_name ->
      assert type == :metric
      assert operation == :increment
      assert metric_name == "error.process.crash"
    end)
  end

  defp expect_no_metric() do
    expect(EventMock, :record, 0, fn _, _, _ -> true end)
  end

  defp cause_crash(reason) do
    try do
      TestCrashingServer.crash(reason)
    catch
      :exit, _ -> nil
    end
  end
end
