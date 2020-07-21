defmodule Belfrage.Metrics.Pool do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :pool_observer)
  end

  def send() do
    pools = Supervisor.which_children(MachineGun.Supervisor)

    pools
    |> active_workers()
    |> send_metrics("http.pools.active_workers")

    pools
    |> all_workers()
    |> send_metrics("http.pools.all_workers")
  end

  def send_metrics(metrics, metric_name) do
    Enum.each(metrics, fn metric -> ExMetrics.increment(metric_name, metric) end)
  end

  def all_workers(pools) do
    call_pools(pools, :status)
    |> Enum.map(fn {_, free_workers, _, active_workers} -> free_workers + active_workers end)
  end

  def active_workers(pools) do
    call_pools(pools, :status)
    |> Enum.map(fn {_, _, _, active_workers} -> active_workers end)
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
    rate = Application.get_env(:belfrage, :pool_metric_rate)
    Process.send_after(self(), :loop, rate)
  end

  defp call_pools(pools, generver_term) do
    pools
    |> Enum.map(fn {_, pool_pid, _, _} -> GenServer.call(pool_pid, generver_term) end)
  end
end
