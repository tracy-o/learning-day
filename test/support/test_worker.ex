defmodule Belfrage.Metrics.PoolObserverTest.TestWorker do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], [])
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:work, _from, state) do
    :timer.sleep(2000)
    {:reply, [], state}
  end

  def work(pid) do
    GenServer.call(pid, :work)
  end
end
