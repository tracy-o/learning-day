defmodule Belfrage.RouteState do
  use GenServer, restart: :temporary

  alias Belfrage.{Counter, RouteStateRegistry, RouteSpecManager, Envelope, CircuitBreaker, Mvt, RouteSpec}
  require Logger

  @fetch_route_state_timeout Application.compile_env(:belfrage, :fetch_route_state_timeout)

  @spec start_link(
          {RouteSpec.name(), RouteSpec.platform()}
          | {RouteSpec.name(), RouteSpec.platform(), non_neg_integer | String.t()}
        ) :: {:ok, pid()}
  def start_link(id) do
    spec_name_platform = get_spec_name_platform(id)

    case RouteSpecManager.get_spec(spec_name_platform) do
      nil ->
        :telemetry.execute([:belfrage, :route_spec, :not_found], %{}, %{route_spec: format_id(spec_name_platform)})
        reason = "Route spec '#{spec_name_platform}' not found"
        Logger.log(:error, "", %{msg: reason})
        {:error, reason}

      spec ->
        GenServer.start_link(__MODULE__, {id, spec}, name: via_tuple(id))
    end
  end

  def state(id, timeout \\ @fetch_route_state_timeout) do
    try do
      GenServer.call(via_tuple(id), :state, timeout)
    catch
      :exit, value ->
        :telemetry.execute([:belfrage, :route_state, :fetch, :timeout], %{count: 1})
        Kernel.exit(value)
    end
  end

  def inc(%Envelope{
        private: %Envelope.Private{route_state_id: id, origin: origin},
        response: %Envelope.Response{http_status: http_status, fallback: fallback}
      }) do
    GenServer.cast(via_tuple(id), {:inc, http_status, origin, fallback})
  end

  @doc """
  Checks that the response is not a fallback and that there are MVT vary headers.
  If the above is true, then an {:update, http_status, origin, fallback, vary_headers}
  message is sent. Otherwise inc/1 is called.
  """
  def update(
        envelope = %Envelope{
          private: %Envelope.Private{route_state_id: id, origin: origin},
          response: %Envelope.Response{http_status: http_status, fallback: fallback}
        }
      ) do
    case {fallback, Mvt.State.get_vary_headers(envelope.response)} do
      {false, vary_headers = [_ | _]} ->
        GenServer.cast(via_tuple(id), {:update, http_status, origin, vary_headers})

      _ ->
        inc(envelope)
    end
  end

  def via_tuple(id) do
    RouteStateRegistry.via_tuple({__MODULE__, id})
  end

  def format_id(nil), do: nil
  def format_id({spec, platform}), do: "#{spec}.#{platform}"
  def format_id({spec, platform, partition}), do: "#{spec}.#{platform}.#{partition}"

  # callbacks

  @impl GenServer
  def init({id, spec}) do
    Process.send_after(self(), :reset, route_state_reset_interval())

    spec_map =
      spec
      |> Map.from_struct()
      |> Map.put(:spec, Map.get(spec, :name))
      |> Map.delete(:name)

    {:ok,
     Map.merge(spec_map, %{
       route_state_id: id,
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
        mvt_seen: Mvt.State.put_vary_headers(state.mvt_seen, mvt_vary_headers)
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

    mvt_seen =
      state
      |> Map.get(:mvt_seen)
      |> Mvt.State.prune_vary_headers(mvt_vary_header_ttl())

    Belfrage.Metrics.measurement(~w(circuit_breaker throughput)a, %{throughput: next_throughput}, %{
      route_spec: format_id(state.route_state_id)
    })

    state = %{state | counter: Counter.init(), throughput: next_throughput, mvt_seen: mvt_seen}
    {:noreply, state}
  end

  defp route_state_reset_interval do
    Application.get_env(:belfrage, :route_state_reset_interval)
  end

  defp mvt_vary_header_ttl() do
    Application.get_env(:belfrage, :mvt_vary_header_ttl)
  end

  defp circuit_breaker_open(0, route_state_id) do
    Belfrage.Metrics.event(~w(circuit_breaker open)a, %{route_spec: format_id(route_state_id)})
  end

  defp circuit_breaker_open(_throughput, _route_state_id), do: false

  defp get_spec_name_platform({spec, platform}), do: {spec, platform}
  defp get_spec_name_platform({spec, platform, _partition}), do: {spec, platform}
end
