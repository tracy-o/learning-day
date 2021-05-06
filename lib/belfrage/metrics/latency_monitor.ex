defmodule Belfrage.Metrics.LatencyMonitor do
  use GenServer

  @cleanup_rate 10_000
  @cleanup_ttl 30_000
  @valid_checkpoints [:request_start, :request_end, :response_start, :response_end]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def checkpoint(request_id, name), do: checkpoint(request_id, name, get_time())

  def checkpoint(request_id, name, time) do
    GenServer.cast(__MODULE__, {:checkpoint, name, request_id, time})
  end

  def discard(request_id) do
    GenServer.cast(__MODULE__, {:discard, request_id})
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
    Map.get(state, request_id)
    |> Map.put(:response_end, time)
    |> send_metrics()

    {:noreply, remove_request_id(state, request_id)}
  end

  @impl GenServer
  def handle_cast({:checkpoint, name, request_id, time}, state) when name in @valid_checkpoints,
    do: {:noreply, append_time(state, request_id, name, time)}

  @impl GenServer
  def handle_cast({:discard, request_id}, state), do: {:noreply, remove_request_id(state, request_id)}

  defp append_time(state, request_id, name, time) do
    new_times =
      Map.get(state, request_id, %{})
      |> append_time(name, time)

    Map.put(state, request_id, new_times)
  end

  defp append_time(times, name, time) when name in @valid_checkpoints, do: Map.put(times, name, time)

  defp remove_request_id(state, request_id), do: Map.delete(state, request_id)

  defp send_metrics(%{request_start: req_start, request_end: req_end, response_start: res_start, response_end: res_end}) do
    request_latency = compute_latency(req_start, req_end)
    response_latency = compute_latency(res_start, res_end)
    combined_latency = request_latency + response_latency

    ExMetrics.timing("web.latency.internal.request", request_latency)
    ExMetrics.timing("web.latency.internal.response", response_latency)
    ExMetrics.timing("web.latency.internal.combined", combined_latency)

    {:ok, true}
  end

  defp send_metrics(_), do: {:error, :incomplete_times}

  defp compute_latency(start_time, end_time), do: end_time - start_time

  defp schedule_work(), do: Process.send_after(__MODULE__, :cleanup, @cleanup_rate)

  defp perform_cleanup(state), do: perform_cleanup(state, get_time() - @cleanup_ttl)
  defp perform_cleanup(state, ttl_threshold), do: :maps.filter(is_request_alive(ttl_threshold), state)

  defp is_request_alive(ttl_threshold), do: &is_request_alive(&1, &2, ttl_threshold)
  defp is_request_alive(_, %{request_start: start}, ttl_threshold), do: start > ttl_threshold
  defp is_request_alive(_request_id, _times, _ttl_threshold), do: false

  defp get_time(), do: System.monotonic_time(:nanosecond) / 1_000_000
end
