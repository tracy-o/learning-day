defmodule Belfrage.RouteState do
  use GenServer, restart: :temporary

  alias Belfrage.{Counter, RouteStateRegistry, Struct, RouteSpec, Metrics.Statix, Event, CircuitBreaker, Mvt}

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

  @doc """
  Checks that the response is not a fallback and that there are MVT vary headers.
  If the above is true, then an {:update, http_status, origin, fallback, vary_headers}
  message is sent. Otherwise inc/1 is called.
  """
  def update(
        struct = %Struct{
          private: %Struct.Private{route_state_id: name, origin: origin},
          response: %Struct.Response{http_status: http_status, fallback: fallback}
        }
      ) do
    case {fallback, Mvt.State.get_vary_headers(struct)} do
      {false, vary_headers = [_ | _]} ->
        GenServer.cast(via_tuple(name), {:update, http_status, origin, vary_headers})

      _ ->
        inc(struct)
    end
  end

  defp via_tuple(name) do
    RouteStateRegistry.via_tuple({__MODULE__, name})
  end

  # callbacks

  @impl GenServer
  def init(specs) do
    Process.send_after(self(), :reset, route_state_reset_interval())

    specs = Map.from_struct(specs)

    {:ok,
     Map.merge(specs, %{
       counter: Counter.init(),
       mvt_seen: %{},
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

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status, origin, _fallback}, state) do
    state = %{state | counter: Counter.inc(state.counter, http_status, origin)}
    {:noreply, state}
  end

  def handle_cast({:update, http_status, origin, mvt_vary_headers}, state) do
    state = %{
      state
      | counter: Counter.inc(state.counter, http_status, origin),
        mvt_seen: Mvt.State.put_mvt_vary_headers(state.mvt_seen, mvt_vary_headers)
    }

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:reset, state = %{throughput: throughput}) do
    Process.send_after(self(), :reset, route_state_reset_interval())

    next_throughput =
      state
      |> CircuitBreaker.threshold_exceeded?()
      |> CircuitBreaker.next_throughput(throughput)

    circuit_breaker_open(next_throughput, state.route_state_id)

    Belfrage.Metrics.measurement(~w(circuit_breaker throughput)a, %{throughput: next_throughput}, %{
      route_spec: state.route_state_id
    })

    state = %{state | counter: Counter.init(), throughput: next_throughput}
    {:noreply, state}
  end

  defp route_state_reset_interval do
    Application.get_env(:belfrage, :route_state_reset_interval)
  end

  defp circuit_breaker_open(0, route_state_id) do
    Belfrage.Metrics.event(~w(circuit_breaker open)a, %{route_spec: route_state_id})
  end

  defp circuit_breaker_open(_throughput, _route_state_id), do: false
end
