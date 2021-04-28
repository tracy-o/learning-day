defmodule Belfrage.Metrics.LatencyMonitor.Times do
  defstruct request_start: nil,
            request_end: nil,
            response_start: nil,
            response_end: nil

  @type t :: %__MODULE__{}
end

defmodule Belfrage.Metrics.LatencyMonitor do
  use GenServer

  alias Belfrage.LatencyMonitor.{Times}

  @cleanup_rate 10_000
  @cleanup_ttl 30_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def checkpoint(request_id, name) do
    time = System.monotonic_time()
    GenServer.cast(__MODULE__, {:checkpoint, name, request_id, time})
  end

  @impl GenServer
  def init(_opts) do
    send(self(), :cleanup)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:cleanup, state) do
    schedule_work()
    {:noreply, perform_cleanup(state)}
  end

  @impl GenServer
  def handle_info(_, state), do: {:noreply, state}

  @impl GenServer
  def handle_cast({:checkpoint, :response_send, request_id, time}, _from, state) do
    send_metrics(%Times{Map.get(state, request_id) | response_send: time}, request_id)
    {:noreply, remove_request_id(state, request_id)}
  end

  @impl GenServer
  def handle_cast({:checkpoint, name, request_id, time}, _from, state) do
    {:noreply, append_time(state, request_id, name, time)}
  end

  defp append_time(state, request_id, name, time) do
    new_times =
      Map.get(state, request_id, %Times{})
      |> append_time(name, time)

    %{state | request_id => new_times}
  end

  defp append_time(%Times{} = times, name, time), do: %Times{times | name => time}

  defp remove_request_id(state, request_id), do: Map.delete(state, request_id)

  defp send_metrics(state, request_id), do: Map.get(state, request_id) |> send_metrics()

  defp send_metrics(%Times{} = times) when is_integer(times.response_end) do
    request_latency = times.request_end - times.request_start
    response_latency = times.response_end - times.response_start

    durations = %{
      request_latency: request_latency / 1_000,
      response_latency: response_latency / 1_000,
      combined_latency: (request_latency + response_latency) / 1_000
    }

    ExMetrics.timing("web.latency.internal.request", durations.request_latency)
    ExMetrics.timing("web.latency.internal.response", durations.response_latency)
    ExMetrics.timing("web.latency.internal.combined", durations.combined_latency)

    {:ok, true}
  end

  defp send_metrics(%Times{} = times), do: {:error, :incomplete_times}

  defp schedule_work, do: Process.send_after(__MODULE__, :cleanup, @cleanup_rate)

  defp perform_cleanup(state), do: perform_cleanup(state, System.monotonic_time() - @cleanup_ttl)
  defp perform_cleanup(state, ttl_threshold), do: Enum.filter(state, is_request_alive(ttl_threshold))

  defp is_request_alive(ttl_threshold), do: &is_request_alive(&1, ttl_threshold)
  defp is_request_alive({_, times}, ttl_threshold), do: times.request_start > ttl_threshold
end
