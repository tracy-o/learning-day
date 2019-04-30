defmodule Ingress.Loop do
  use GenServer, restart: :temporary

  alias Ingress.{Counter, LoopsRegistry, Struct}

  @threshold Application.get_env(:ingress, :errors_threshold)
  @interval Application.get_env(:ingress, :circuit_breaker_reset_interval)
  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(name))
  end

  def state(%Struct{private: %Struct.Private{loop_id: name}}) do
    GenServer.call(via_tuple(name), {:state, name})
  end

  def inc(%Struct{
        private: %Struct.Private{loop_id: name},
        response: %Struct.Response{http_status: http_status}
      }) do
    GenServer.cast(via_tuple(name), {:inc, http_status})
  end

  defp via_tuple(name) do
    LoopsRegistry.via_tuple({__MODULE__, name})
  end

  # callbacks

  @impl GenServer
  def init(_) do
    Process.send_after(self(), :reset, @interval)

    {:ok, %{counter: Counter.init(), pipeline: ["MyTransformer1"]}}
  end

  @impl GenServer
  def handle_call({:state, loop_id}, _from, state) do
    exceed = Counter.exceed?(state.counter, :errors, @threshold)

    {:reply, {:ok, Map.merge(state, %{origin: origin_pointer(exceed, loop_id)})}, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status}, state) do
    state = %{state | counter: Counter.inc(state.counter, http_status, state.origin)}

    {:noreply, state}
  end

  # Resets the counter at every window.
  # TODO: Before resetting it should send
  # the counter to the Controller app.
  @impl GenServer
  def handle_info(:reset, state) do
    Process.send_after(self(), :reset, @interval)
    state = %{state | counter: Counter.init()}

    {:noreply, state}
  end

  @legacy_routes ["mondo", "legacy", "legacy_page_type", "legacy_page_type_with_id"]

  defp origin_pointer(false, loop_id) do
    case Enum.member?(@legacy_routes, loop_id) do
      true -> Application.get_env(:ingress, :origin)
      false -> Application.get_env(:ingress, :lambda_presentation_layer)
    end
  end

  defp origin_pointer(true, _) do
    ExMetrics.increment("error.loop.threshold.exceeded")
    Stump.log(:error, "Error threshold exceeded for loop")
    Application.get_env(:ingress, :fallback)
  end
end
