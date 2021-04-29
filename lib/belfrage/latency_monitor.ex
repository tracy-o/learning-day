defmodule Belfrage.LatencyMonitor.Timings do
  defstruct request_start: nil,
            request_end: nil,
            response_start: nil,
            response_end: nil

  @type t :: %__MODULE__{}
end

defmodule Belfrage.LatencyMonitor do
  use GenServer

  alias Belfrage.LatencyMonitor.{Timings}

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
  def handle_info(:cleanup, _old) do
    schedule_work()
    perform_cleanup()
  end

  # Catch all to handle unexpected messages
  # https://elixir-lang.org/getting-started/mix-otp/genserver.html#call-cast-or-info
  @impl GenServer
  def handle_info(_any_message, state), do: {:noreply, state}

  @impl GenServer
  def handle_cast({:checkpoint, :response_send, request_id, time}, _from, state) do
    send_metrics(%Timings{Map.get(state, request_id) | response_send: time}, request_id)
    {:noreply, remove_request_id(state, request_id)}
  end

  @impl GenServer
  def handle_cast({:checkpoint, name, request_id, time}, _from, state) do
    {:noreply, append_time(state, request_id, name, time)}
  end

  defp schedule_work do
    Process.send_after(__MODULE__, :cleanup, @cleanup_rate)
  end

  defp append_time(state, request_id, name, time) do
    %{state | request_id => %Timings{Map.get(state, request_id, %Timings{}) | name => time}}
  end

  defp remove_request_id(state, request_id), do: Map.delete(state, request_id)

  defp perform_cleanup(state), do: perform_cleanup(state, System.monotonic_time() - @cleanup_ttl)

  defp perform_cleanup(state, ttl_threshold) do
    {:noreply, Enum.filter(state, fn {_k, v} -> Map.get(v, :request_start, 0) > ttl_threshold end)}
  end

  defp send_metrics(state, request_id), do: Map.get(state, request_id) |> send_metrics()

  defp send_metrics(%Timings{} = timings) when is_integer(timings.response_end) do
    request_latency = timings.request_end - timings.request_start
    response_latency = timings.response_end - timings.response_start

    durations = %{
      request_latency: request_latency / 1_000,
      response_latency: response_latency / 1_000,
      combined_latency: (request_latency + response_latency) / 1_000
    }

    ExMetrics.timing("web.latency.internal.request", durations.request_latency)
    ExMetrics.timing("web.latency.internal.response", durations.response_latency)
    ExMetrics.timing("web.latency.internal.combined", durations.combined_latency)
  end
end
