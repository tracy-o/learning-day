defmodule Belfrage.PoolMetrics do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :pool_observer)
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

  def send() do
    supervisor = Supervisor.which_children(MachineGun.Supervisor)

    supervisor
    |> active_workers()
    |> send_metrics("http.pools.active_workers")

    supervisor
    |> all_workers()
    |> send_metrics("http.pools.all_workers")
  end

  def send_metrics(metrics, metric_name) do
    Enum.each(metrics, fn metric -> ExMetrics.increment(metric_name, metric) end)
  end

  def all_workers(pools) do
    call_pools(pools, :get_all_workers)
    |> Enum.map(&Enum.count/1)
  end

  def active_workers(pools) do
    Enum.zip(all_workers(pools), available_workers(pools))
    |> Enum.map(fn {all, avail} -> all - avail end)
  end

  defp available_workers(pools) do
    call_pools(pools, :get_avail_workers)
    |> Enum.map(&Enum.count/1)
  end

  defp loop() do
    Process.send_after(self(), :loop, 1_000)
  end

  defp call_pools(pools, generver_term) do
    pools
    |> Enum.map(fn {_, pool_pid, _, _} -> GenServer.call(pool_pid, generver_term) end)
  end
end
