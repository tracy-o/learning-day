defmodule Belfrage.Loop do
  use GenServer, restart: :temporary

  alias Belfrage.{Counter, LoopsRegistry, Struct}

  @short_interval Application.get_env(:belfrage, :short_counter_reset_interval)
  @long_interval Application.get_env(:belfrage, :long_counter_reset_interval)
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
    Process.send_after(self(), :short_reset, @short_interval)
    Process.send_after(self(), :long_reset, @long_interval)

    {:ok,
     Map.merge(specs, %{
       counter: Counter.init(),
       long_counter: Counter.init()
     })}
  end

  @impl GenServer
  def handle_call({:state, loop_id}, _from, state) do
    {:reply, {:ok, Map.merge(state, %{origin: origin_pointer(state.platform)})}, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status, origin, true}, state) do
    state = %{state | counter: Counter.inc(state.counter, :fallback, origin)}
    state = %{state | counter: Counter.inc(state.counter, http_status, origin)}
    state = %{state | long_counter: Counter.inc(state.long_counter, :fallback, origin)}
    state = %{state | long_counter: Counter.inc(state.long_counter, http_status, origin)}

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:inc, http_status, origin, _fallback}, state) do
    state = %{state | counter: Counter.inc(state.counter, http_status, origin)}
    state = %{state | long_counter: Counter.inc(state.long_counter, http_status, origin)}

    {:noreply, state}
  end

  # Resets the counter at every window.
  # TODO: Before resetting it should send
  # the counter to the Controller app.
  @impl GenServer
  def handle_info(:short_reset, state) do
    Belfrage.Monitor.record_loop(state)
    Process.send_after(self(), :short_reset, @short_interval)
    state = %{state | counter: Counter.init()}

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:long_reset, state) do
    Process.send_after(self(), :long_reset, @long_interval)
    state = %{state | long_counter: Counter.init()}
    {:noreply, state}
  end

  # TODO: discuss is these belong to the loop or to a transformer or to the service domain.

  defp origin_pointer(:webcore) do
    Application.get_env(:belfrage, :pwa_lambda_function)
  end

  defp origin_pointer(:origin_simulator) do
    Application.get_env(:belfrage, :origin_simulator)
  end

  defp origin_pointer(:mozart) do
    Application.get_env(:belfrage, :mozart_endpoint)
  end

  defp origin_pointer(:pal) do
    Application.get_env(:belfrage, :pal_endpoint)
  end

  defp origin_pointer(:fabl) do
    Application.get_env(:belfrage, :fabl_endpoint)
  end
end
