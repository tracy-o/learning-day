defmodule Belfrage.Loop do
  use GenServer, restart: :temporary

  alias Belfrage.{Counter, LoopsRegistry, Struct}

  @threshold Application.get_env(:belfrage, :errors_threshold)
  @interval Application.get_env(:belfrage, :circuit_breaker_reset_interval)
  def start_link(name) do
    GenServer.start_link(__MODULE__, specs_for(name), name: via_tuple(name))
  end

  def state(%Struct{private: %Struct.Private{loop_id: name}}) do
    GenServer.call(via_tuple(name), {:state, name})
  end

  def inc(%Struct{
        private: %Struct.Private{loop_id: name, origin: origin},
        response: %Struct.Response{http_status: http_status, fallback: fallback}
      }) do
    GenServer.cast(via_tuple(name), {:inc, http_status, origin, fallback})
  end

  defp via_tuple(name) do
    LoopsRegistry.via_tuple({__MODULE__, name})
  end

  defp specs_for(name) do
    Module.concat([Routes, Specs, name]).specs()
    |> Map.put(:loop_id, name)
  end

  # callbacks

  @impl GenServer
  def init(specs) do
    Process.send_after(self(), :reset, @interval)

    {:ok, Map.put(specs, :counter, Counter.init())}
  end

  @impl GenServer
  def handle_call({:state, loop_id}, _from, state) do
    {:reply, {:ok, Map.merge(state, %{origin: origin_pointer(loop_id, state.platform)})}, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status, origin, true}, state) do
    state = %{state | counter: Counter.inc(state.counter, :fallback, origin)}
    state = %{state | counter: Counter.inc(state.counter, http_status, origin)}

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status, origin, _fallback}, state) do
    state = %{state | counter: Counter.inc(state.counter, http_status, origin)}

    {:noreply, state}
  end

  # Resets the counter at every window.
  # TODO: Before resetting it should send
  # the counter to the Controller app.
  @impl GenServer
  def handle_info(:reset, state) do
    Belfrage.Monitor.record_loop(state)
    Process.send_after(self(), :reset, @interval)
    state = %{state | counter: Counter.init()}

    {:noreply, state}
  end

  # TODO: discuss is these belong to the loop or to a trnsformer or to the service domain.

  defp origin_pointer("ContainerData", :webcore) do
    Application.get_env(:belfrage, :api_lambda_function)
  end

  defp origin_pointer(_, :webcore) do
    Application.get_env(:belfrage, :pwa_lambda_function)
  end

  defp origin_pointer(_, :origin_simulator) do
    Application.get_env(:belfrage, :origin_simulator)
  end
end
