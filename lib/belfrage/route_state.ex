defmodule Belfrage.RouteState do
  use GenServer, restart: :temporary

  alias Belfrage.{Counter, RouteStateRegistry, Struct, RouteSpec, Metrics.Statix, Event, CircuitBreaker}

  @fetch_route_state_timeout Application.get_env(:belfrage, :fetch_route_state_timeout)

  def start_link(name) do
    GenServer.start_link(__MODULE__, RouteSpec.specs_for(name), name: via_tuple(name))
  end

  def state(%Struct{private: %Struct.Private{route_state_id: name}}, timeout \\ @fetch_route_state_timeout) do
    try do
      GenServer.call(via_tuple(name), :state, timeout)
    catch
      :exit, value ->
        Statix.increment("route_state.state.fetch.timeout", 1, tags: Event.global_dimensions())
        Kernel.exit(value)
    end
  end

  def inc(%Struct{
        private: %Struct.Private{route_state_id: name, origin: origin},
        response: %Struct.Response{http_status: http_status, fallback: fallback}
      }) do
    GenServer.cast(via_tuple(name), {:inc, http_status, origin, fallback})
  end

  defp via_tuple(name) do
    RouteStateRegistry.via_tuple({__MODULE__, name})
  end

  # callbacks

  @impl GenServer
  def init(specs) do
    Process.send_after(self(), :short_reset, short_interval())
    Process.send_after(self(), :long_reset, long_interval())

    specs = Map.from_struct(specs)

    {:ok,
     Map.merge(specs, %{
       counter: Counter.init(),
       long_counter: Counter.init(),
       throughput: 100
     })}
  end

  @impl GenServer
  def handle_call(:state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status, origin, true}, state) do
    state = %{state | counter: Counter.inc(state.counter, http_status, origin, fallback: true)}
    state = %{state | long_counter: Counter.inc(state.long_counter, http_status, origin, fallback: true)}

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status, origin, _fallback}, state) do
    state = %{state | counter: Counter.inc(state.counter, http_status, origin)}
    state = %{state | long_counter: Counter.inc(state.long_counter, http_status, origin)}

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:short_reset, state) do
    Belfrage.Monitor.record_route_state(state)
    Process.send_after(self(), :short_reset, short_interval())
    state = %{state | counter: Counter.init()}

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:long_reset, state = %{throughput: throughput}) do
    Process.send_after(self(), :long_reset, long_interval())

    next_throughput =
      state
      |> CircuitBreaker.threshold_exceeded?()
      |> CircuitBreaker.next_throughput(throughput)

    Belfrage.Metrics.measurement(~w(circuit_breaker throughput)a, %{thoughput: next_throughput}, %{
      route_spec: state.route_state_id
    })

    state = %{state | long_counter: Counter.init(), throughput: next_throughput}
    {:noreply, state}
  end

  defp short_interval do
    Application.get_env(:belfrage, :short_counter_reset_interval)
  end

  defp long_interval do
    Application.get_env(:belfrage, :long_counter_reset_interval)
  end
end
