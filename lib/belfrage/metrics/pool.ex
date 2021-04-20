defmodule Belfrage.Metrics.Pool do
  use GenServer, restart: :temporary

  @rate Application.get_env(:belfrage, :pool_metric_rate)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :pool_observer)
  end

  def send() do
    pools = Supervisor.which_children(MachineGun.Supervisor)

    pools
    |> get_workers()
    |> send_metric("http.pools.size")

    pools
    |> get_overflow()
    |> send_metric("http.pools.overflow")
  end

  def send_metric(metric, metric_name) do
    Belfrage.Event.record(:metric, :gauge, metric_name, value: metric)
  end

  def get_workers([]), do: 0

  def get_workers(pools) do
    call_pools(pools, :status)
    |> Enum.map(fn {_state_name, workers, _overflow, _monitors} -> workers end)
    |> Enum.max()
  end

  def get_overflow([]), do: 0

  def get_overflow(pools) do
    call_pools(pools, :status)
    |> Enum.map(fn {_state_name, _workers, overflow, _monitors} -> overflow end)
    |> Enum.max()
  end

  # callbacks
  @impl true
  def init(init) do
    loop()
    {:ok, init}
  end

  @impl true
  def handle_info(:loop, state) do
    send()

    loop()
    {:noreply, state}
  end

  defp loop() do
    Process.send_after(self(), :loop, @rate)
  end

  defp call_pools(pools, generver_term) do
    pools
    |> Enum.map(fn {_id, pool_pid, _type, _modules} -> GenServer.call(pool_pid, generver_term) end)
  end
end
