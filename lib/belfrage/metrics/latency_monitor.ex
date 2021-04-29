defmodule Belfrage.Metrics.LatencyMonitor do
  use GenServer

  @cleanup_rate 10_000
  @cleanup_ttl 30_000
  @valid_checkpoints [:request_start, :request_end, :response_start, :response_end]

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
  def handle_cast({:checkpoint, :response_end, request_id, time}, state) do
    send_metrics(%{Map.get(state, request_id) | response_end: time}, request_id)
    {:noreply, remove_request_id(state, request_id)}
  end

  @impl GenServer
  def handle_cast({:checkpoint, name, request_id, time}, state) when name in @valid_checkpoints do
    {:noreply, append_time(state, request_id, name, time)}
  end

  defp append_time(state, request_id, name, time) do
    new_times =
      Map.get(state, request_id, %{})
      |> append_time(name, time)

    %{state | request_id => new_times}
  end

  defp append_time(times, name, time) when name in @valid_checkpoints, do: %{times | name => time}

  defp remove_request_id(state, request_id), do: Map.delete(state, request_id)

  defp send_metrics(state, request_id), do: Map.get(state, request_id) |> send_metrics()
  defp send_metrics(%{response_end: t}) when is_nil(t), do: {:error, :incomplete_times}

  defp send_metrics(times) do
    request_latency = compute_latency(times.request_start, times.request_end)
    response_latency = compute_latency(times.response_start, times.response_end)
    combined_latency = request_latency + response_latency

    ExMetrics.timing("web.latency.internal.request", request_latency)
    ExMetrics.timing("web.latency.internal.response", response_latency)
    ExMetrics.timing("web.latency.internal.combined", combined_latency)

    {:ok, true}
  end

  defp compute_latency(start_time, end_time), do: (end_time - start_time) / 1_000

  defp schedule_work(), do: Process.send_after(__MODULE__, :cleanup, @cleanup_rate)

  defp perform_cleanup(state), do: perform_cleanup(state, System.monotonic_time() - @cleanup_ttl)
  defp perform_cleanup(state, ttl_threshold), do: Enum.filter(state, is_request_alive(ttl_threshold))

  defp is_request_alive(ttl_threshold), do: &is_request_alive(&1, ttl_threshold)
  defp is_request_alive({_, times}, ttl_threshold), do: times.request_start > ttl_threshold
end
