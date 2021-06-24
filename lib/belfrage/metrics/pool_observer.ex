defmodule Belfrage.Metrics.PoolObserver do
  use GenServer

  @rate Application.get_env(:belfrage, :pool_metric_rate)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  defp send() do
    data = list_pids() |> get_data()
    send_metric("size", data.number_of_workers)
    send_metric("overflow", data.number_of_overflow_workers)
  end

  defp list_pids() do
    MachineGun.Supervisor
    |> Supervisor.which_children()
    |> Enum.map(fn {_id, pid, _type, _modules} -> pid end)
  end

  def get_data(pids) when is_list(pids) do
    data = Enum.map(pids, &get_data/1)

    %{
      number_of_workers: data |> attr(:number_of_workers) |> Enum.min(fn -> 0 end),
      number_of_overflow_workers: data |> attr(:number_of_overflow_workers) |> Enum.max(fn -> 0 end)
    }
  end

  def get_data(pid) do
    {_state_name, workers, overflow, _monitors} = :poolboy.status(pid)
    %{number_of_workers: workers, number_of_overflow_workers: overflow}
  end

  defp attr(data, key) do
    Enum.map(data, &Map.fetch!(&1, key))
  end

  def send_metric(name, value) do
    Belfrage.Event.record(:metric, :gauge, "http.pools.#{name}", value: value)
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

  @impl true
  def handle_info(_, state), do: {:noreply, state}

  defp loop() do
    Process.send_after(self(), :loop, @rate)
  end
end
