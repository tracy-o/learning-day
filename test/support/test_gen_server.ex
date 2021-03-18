defmodule Belfrage.TestGenServer do
  use GenServer

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, [], name: name)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:work, state) do
    :timer.sleep(2000)
    {:noreply, state}
  end

  def work(name) do
    GenServer.cast(name, :work)
  end
end
