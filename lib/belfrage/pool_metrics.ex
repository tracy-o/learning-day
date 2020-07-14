defmodule Belfrage.PoolMetrics do
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

  @impl true
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
    Stump.log(:error, metrics(supervisor))
  end

  def metrics(supervisor_children) do
    supervisor_children
    |> Enum.map(&pool_map/1)
  end

  defp pool_map(pool) do
    case pool do
      {_, pid, _, _} ->
        %{name: pool_name(pid), all_workers: all_workers(pid), active_workers: active_workers(pid)}

      _ ->
        :error
    end
  end

  defp all_workers(pool) do
    GenServer.call(pool, :get_all_workers)
    |> Enum.count()
  end

  defp available_workers(pool) do
    GenServer.call(pool, :get_avail_workers)
    |> Enum.count()
  end

  defp active_workers(pool) do
    all_workers(pool) - available_workers(pool)
  end

  defp pool_name(pid) do
    Process.info(pid)[:registered_name]
  end
end
