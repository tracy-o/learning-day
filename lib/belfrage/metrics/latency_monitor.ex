defmodule Belfrage.Metrics.LatencyMonitor do
  use GenServer

  @default_cleanup_rate 10_000
  @cleanup_ttl 30_000
  @valid_checkpoints [:request_start, :request_end, :response_start, :response_end]

  def start_link(opts \\ []) do
    rate = Keyword.get(opts, :cleanup_rate, @default_cleanup_rate)
    GenServer.start_link(__MODULE__, %{cleanup_rate: rate}, name: __MODULE__)
  end

  def checkpoint(request_id, name), do: checkpoint(request_id, name, get_time())

  def checkpoint(request_id, name, time) do
    GenServer.cast(__MODULE__, {:checkpoint, name, request_id, time})
  end

  def discard(request_id) do
    GenServer.cast(__MODULE__, {:discard, request_id})
  end

  @impl GenServer
  def init(opts) do
    send(self(), {:cleanup, opts.cleanup_rate})
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info({:cleanup, cleanup_rate}, state) do
    schedule_work(cleanup_rate)
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
  def handle_cast({:checkpoint, name, request_id, time}, state) when name in @valid_checkpoints do
    request_times =
      state
      |> Map.get(request_id, %{})
      |> Map.put(name, time)

    {:noreply, Map.put(state, request_id, request_times)}
  end

  @impl GenServer
  def handle_cast({:discard, request_id}, state), do: {:noreply, remove_request_id(state, request_id)}

  defp remove_request_id(state, request_id), do: Map.delete(state, request_id)

  defp send_metrics(%{request_start: req_start, request_end: req_end, response_start: res_start, response_end: res_end}) do
    request_latency = compute_latency(req_start, req_end)
    response_latency = compute_latency(res_start, res_end)
    combined_latency = request_latency + response_latency

    Belfrage.Metrics.Statix.timing("web.latency.internal.request", request_latency)
    Belfrage.Metrics.Statix.timing("web.latency.internal.response", response_latency)
    Belfrage.Metrics.Statix.timing("web.latency.internal.combined", combined_latency)

    {:ok, true}
  end

  defp send_metrics(_), do: {:error, :incomplete_times}

  defp compute_latency(start_time, end_time), do: end_time - start_time

  defp schedule_work(cleanup_rate), do: Process.send_after(__MODULE__, {:cleanup, cleanup_rate}, cleanup_rate)

  defp perform_cleanup(state), do: perform_cleanup(state, get_time() - @cleanup_ttl)
  defp perform_cleanup(state, ttl_threshold), do: :maps.filter(is_request_alive(ttl_threshold), state)

  defp is_request_alive(ttl_threshold), do: &is_request_alive(&1, &2, ttl_threshold)
  defp is_request_alive(_, %{request_start: start}, ttl_threshold), do: start > ttl_threshold
  defp is_request_alive(_request_id, _times, _ttl_threshold), do: false

  defp get_time(), do: System.monotonic_time(:nanosecond) / 1_000_000
end
