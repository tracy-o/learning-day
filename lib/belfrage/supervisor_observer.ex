defmodule Belfrage.SupervisorObserver do
  use GenServer, restart: :temporary
  require Logger

  @default_sup_observer_timer_ms 30_000

  def start_link(args, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, args, name: name)
  end

  def get_state(name) do
    GenServer.call(name, :state)
  end

  @impl GenServer
  def init(observed_ids) do
    Process.flag(:trap_exit, true)
    start_timer()

    {:ok, %{observed_ids: observed_ids, monitor_map: []}}
  end

  @impl GenServer
  def handle_call(:state, _, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_info(
        :timer,
        state = %{
          observed_ids: observed_ids,
          monitor_map: monitors
        }
      ) do
    new_monitors =
      for id <- observed_ids,
          process_alive?(id),
          !Keyword.has_key?(monitors, id),
          do: {id, Process.monitor(id)}

    upd_monitors = monitors ++ new_monitors
    send_total_observed_metric(upd_monitors)
    start_timer()
    {:noreply, %{state | monitor_map: upd_monitors}}
  end

  def handle_info(
        {:DOWN, _, :process, {id, _}, reason},
        state = %{monitor_map: monitors}
      ) do
    upd_monitors = Keyword.delete(monitors, id)
    :telemetry.execute([:belfrage, :child, :supervisor, :is, :down], %{}, %{supervisor_id: id})
    send_total_observed_metric(upd_monitors)
    Logger.log(:error, "", %{msg: "Observed process #{id} is down", reason: reason})
    {:noreply, %{state | monitor_map: upd_monitors}}
  end

  defp start_timer() do
    sup_observer_timer_ms =
      Application.get_env(
        :belfrage,
        :sup_observer_timer_ms,
        @default_sup_observer_timer_ms
      )

    Process.send_after(self(), :timer, sup_observer_timer_ms)
  end

  defp send_total_observed_metric(monitors) do
    :telemetry.execute([:belfrage, :observed, :supervisors, :total], %{number: length(monitors)})
  end

  defp process_alive?(id) do
    case Process.whereis(id) do
      nil -> false
      pid -> Process.alive?(pid)
    end
  end
end
