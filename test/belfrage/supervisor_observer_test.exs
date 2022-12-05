defmodule Belfrage.SupervisorObserverTest do
  use ExUnit.Case, async: false
  import Test.Support.Helper, only: [wait_for: 3]

  alias Belfrage.SupervisorObserver
  alias Belfrage.SupervisorObserverTest, as: Test

  @monitored_id Test.MonitoredSup

  setup_all do
    start_supervised!(@monitored_id)

    start_supervised!(%{
      id: TestObserver,
      start: {SupervisorObserver, :start_link, [[@monitored_id], [name: TestObserver]]}
    })

    :ok
  end

  test "init, fail and restart observed supervisor" do
    assert_observer_state([@monitored_id])

    pid = Process.whereis(@monitored_id)
    Process.exit(pid, :kill)
    assert_observer_state([])

    start_supervised!(@monitored_id)
    assert_observer_state([@monitored_id])
  end

  defp assert_observer_state(expected_monitors) do
    wait_for(
      fn -> {[@monitored_id], expected_monitors} == get_observer_state() end,
      100,
      10
    )
  end

  defp get_observer_state() do
    %{monitor_map: m_map, observed_ids: observed_ids} = SupervisorObserver.get_state(TestObserver)
    monitor_ids = for {id, _ref} <- m_map, do: id
    {observed_ids, monitor_ids}
  end

  defmodule MonitoredSup do
    use Supervisor, restart: :temporary

    def start_link(args) do
      Supervisor.start_link(__MODULE__, args, name: __MODULE__)
    end

    def init(_args) do
      Supervisor.init([], strategy: :one_for_one)
    end
  end
end
