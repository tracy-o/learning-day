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

    start_timer()
    {:noreply, %{state | monitor_map: monitors ++ new_monitors}}
  end

  def handle_info(
        {:DOWN, _, :process, {id, _}, reason},
        state = %{monitor_map: monitors}
      ) do
    Logger.log(:error, "", %{msg: "Observed process #{id} is down", reason: reason})
    {:noreply, %{state | monitor_map: Keyword.delete(monitors, id)}}
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

  defp process_alive?(id) do
    case Process.whereis(id) do
      nil -> false
      pid -> Process.alive?(pid)
    end
  end
end
