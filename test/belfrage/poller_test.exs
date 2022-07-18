defmodule Belfrage.PollerTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  import Test.Support.Helper, only: [alive_after?: 2]

  defmodule TestAgent do
    use Agent

    def start_link(_arg) do
      Agent.start_link(fn -> 0 end, name: __MODULE__)
    end

    def set() do
      Agent.update(__MODULE__, &(&1 + 1))
    end

    def get() do
      Agent.get(__MODULE__, & &1)
    end
  end

  defmodule TestPoller do
    alias TestAgent
    use Belfrage.Poller, interval: 200

    @impl Belfrage.Poller
    def poll() do
      TestAgent.set()
      :ok
    end
  end

  defmodule FrequentTestPoller do
    alias TestAgent
    use Belfrage.Poller, interval: 60

    @impl Belfrage.Poller
    def poll() do
      TestAgent.set()
      :ok
    end
  end

  defmodule ErrorPoller do
    alias TestAgent
    use Belfrage.Poller, interval: 60

    @impl Belfrage.Poller
    def poll() do
      raise("some error")
      :ok
    end
  end

  defmodule ThrowPoller do
    alias TestAgent
    use Belfrage.Poller, interval: 60

    @impl Belfrage.Poller
    def poll() do
      throw("some value")
      :ok
    end
  end

  defmodule ExitPoller do
    alias TestAgent
    use Belfrage.Poller, interval: 60

    @impl Belfrage.Poller
    def poll() do
      exit(:poller_exit)
      :ok
    end
  end

  defmodule TimeoutAgent do
    use Agent

    def start_link(_arg) do
      Agent.start_link(fn -> 0 end, name: __MODULE__)
    end

    def set() do
      Agent.update(
        __MODULE__,
        fn _state ->
          Process.sleep(100)
        end,
        50
      )
    end
  end

  defmodule TimeoutPoller do
    alias TestAgent
    use Belfrage.Poller, interval: 60

    @impl Belfrage.Poller
    def poll() do
      TimeoutAgent.set()
      :ok
    end
  end

  describe "polls" do
    setup do
      start_supervised!(TestAgent)
      :ok
    end

    test "on startup" do
      start_supervised!(TestPoller)

      assert TestAgent.get() == 1
    end

    test "after interval" do
      start_supervised!(FrequentTestPoller)
      Process.sleep(100)

      assert TestAgent.get() == 2
    end
  end

  describe "catches" do
    test "thrown values" do
      assert capture_log(fn ->
               start_supervised!(ThrowPoller)
             end) =~
               "Elixir.Belfrage.PollerTest.ThrowPoller failed to poll, the following value was caught: \\\"some value\\\""
    end

    test "exits" do
      assert capture_log(fn ->
               start_supervised!(ExitPoller)
             end) =~ "Elixir.Belfrage.PollerTest.ExitPoller failed to poll, process exited: :poller_exit"
    end

    test "timeout exits" do
      start_supervised!(TimeoutAgent)

      assert capture_log(fn ->
               start_supervised!(TimeoutPoller)
             end) =~
               "Elixir.Belfrage.PollerTest.TimeoutPoller failed to poll, process exited: {:timeout, {GenServer, :call, [Belfrage.PollerTest.TimeoutAgent"
    end

    test "errors" do
      assert capture_log(fn ->
               start_supervised!(ErrorPoller)
             end) =~
               "Elixir.Belfrage.PollerTest.ErrorPoller failed to poll, the following error was rescued: %RuntimeError{message: \\\"some error\\\"}"
    end
  end

  describe "does not restart due to" do
    test "thrown values" do
      assert alive_after?(start_supervised!(ThrowPoller), 100)
    end

    test "exits" do
      assert alive_after?(start_supervised!(ExitPoller), 100)
    end

    test "timeout exits" do
      assert alive_after?(start_supervised!(TimeoutPoller), 100)
    end

    test "errors" do
      assert alive_after?(start_supervised!(ErrorPoller), 100)
    end
  end

  test "messages other than :poll are handled" do
    start_supervised!(TestAgent)
    pid = start_supervised!(TestPoller)
    :erlang.trace(pid, true, [:receive])

    send(pid, :some_other_msg)

    assert_receive {:trace, ^pid, :receive, :some_other_msg}, 100
  end
end
