defmodule Belfrage.Metrics.LatencyMonitor do
  use GenServer

  @default_cleanup_rate 10_000
  @cleanup_ttl 30_000
  @valid_checkpoints [
    :request_received,
    :early_response_received,
    :origin_request_sent,
    :origin_response_received,
    :fallback_request_sent,
    :fallback_response_received,
    :response_sent
  ]

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

  def get_checkpoints(request_id) do
    GenServer.call(__MODULE__, {:get_checkpoints, request_id})
  end

  @impl GenServer
  def init(opts) do
    send(self(), {:cleanup, opts.cleanup_rate})
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info({:cleanup, cleanup_rate}, state) do
    Process.send_after(__MODULE__, {:cleanup, cleanup_rate}, cleanup_rate)

    min_start_time = get_time() - @cleanup_ttl
    state = :maps.filter(fn _request_id, times -> keep_request?(times, min_start_time) end, state)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(_, state), do: {:noreply, state}

  @impl GenServer
  def handle_cast({:checkpoint, :response_sent, request_id, time}, state) do
    request_times = Map.get(state, request_id)

    state =
      if request_times do
        request_times
        |> Map.put(:response_sent, time)
        |> send_metrics()

        remove_request_id(state, request_id)
      else
        state
      end

    {:noreply, state}
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

  @impl GenServer
  def handle_call({:get_checkpoints, request_id}, _from, state) do
    {:reply, Map.get(state, request_id), state}
  end

  defp remove_request_id(state, request_id), do: Map.delete(state, request_id)

  defp send_metrics(checkpoints) do
    request = request_latency(checkpoints)
    response = response_latency(checkpoints)

    if request && response do
      Belfrage.Metrics.Statix.timing("web.latency.internal.request", request)
      Belfrage.Metrics.Statix.timing("web.latency.internal.response", response)
      Belfrage.Metrics.Statix.timing("web.latency.internal.combined", request + response)
    end
  end

  defp request_latency(checkpoints) do
    start = checkpoints[:request_received]
    finish = checkpoints[:early_response_received] || checkpoints[:origin_request_sent]

    if start && finish do
      finish - start
    end
  end

  defp response_latency(checkpoints) do
    start = checkpoints[:early_response_received] || checkpoints[:origin_response_received]
    finish = checkpoints[:response_sent]

    if start && finish do
      finish - start - fallback_latency(checkpoints)
    end
  end

  defp fallback_latency(checkpoints) do
    start = checkpoints[:fallback_request_sent]
    finish = checkpoints[:fallback_response_received]

    if start && finish do
      finish - start
    else
      0
    end
  end

  defp keep_request?(times, min_start_time) do
    Map.has_key?(times, :request_received) && times[:request_received] > min_start_time
  end

  defp get_time(), do: System.monotonic_time(:nanosecond) / 1_000_000
end
