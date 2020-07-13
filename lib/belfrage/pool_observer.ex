defmodule Belfrage.PoolObserver do
  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :pool_observer)
  end

  # callbacks
  @impl true
  def init(init) do
    loop()
    {:ok, init}
  end

  def handle_info(:loop, state) do
    send_metrics()

    loop()
    {:noreply, state}
  end

  defp loop() do
    Process.send_after(self(), :loop, 10_000)
  end

  def send_metrics() do
    supervisor = Supervisor.which_children(MachineGun.Supervisor)

    ExMetrics.increment("machinegun.pools.engaged_worker.min", engaged_workers(supervisor) |> Enum.min())
    ExMetrics.increment("machinegun.pools.engaged_worker.max", engaged_workers(supervisor) |> Enum.max())
    ExMetrics.increment("machinegun.pools.engaged_worker.average", engaged_workers(supervisor) |> average())

    ExMetrics.increment("machinegun.pools.all_workers", all_workers(supervisor) |> Enum.max())
  end

  def all_workers(pools) do
    call_pools(pools, :get_all_workers)
    |> Enum.count()
  end

  def available_workers(pools) do
    call_pools(pools, :get_avail_workers)
    |> Enum.count()
  end

  def engaged_workers(pools) do
    Enum.zip(all_workers(pools), available_workers(pools))
    |> Enum.map(fn [head| tail] -> head - tail end)
  end

  def average(enum) do
    Enum.sum(enum) / Enum.count(enum)
  end

  def call_pools(pools, generver_term) do
    pools
    |> Enum.map(fn [{_, _, pool_pid ,_}] -> GenServer.call(pool_pid, generver_term) end)
  end
end
