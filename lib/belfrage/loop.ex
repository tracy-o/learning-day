defmodule Belfrage.Loop do
  use GenServer, restart: :temporary

  alias Belfrage.{Counter, LoopsRegistry, Struct, RouteSpec}

  @fetch_loop_timeout Application.get_env(:belfrage, :fetch_loop_timeout)

  def start_link(name) do
    GenServer.start_link(__MODULE__, RouteSpec.specs_for(name), name: via_tuple(name))
  end

  def state(%Struct{private: %Struct.Private{loop_id: name}}, timeout \\ @fetch_loop_timeout) do
    try do
      GenServer.call(via_tuple(name), :state, timeout)
    catch
      :exit, value ->
        Belfrage.Metrics.Statix.increment("loop.state.fetch.timeout")
        Kernel.exit(value)
    end
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

  # callbacks

  @impl GenServer
  def init(specs) do
    Process.send_after(self(), :short_reset, short_interval())
    Process.send_after(self(), :long_reset, long_interval())

    {:ok,
     Map.merge(specs, %{
       counter: Counter.init(),
       long_counter: Counter.init()
     })}
  end

  @impl GenServer
  def handle_call(:state, _from, state) do
    {:reply, {:ok, state}, state}
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

  @impl GenServer
  def handle_info(:short_reset, state) do
    Belfrage.Monitor.record_loop(state)
    Process.send_after(self(), :short_reset, short_interval())
    state = %{state | counter: Counter.init()}

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:long_reset, state) do
    Process.send_after(self(), :long_reset, long_interval())
    state = %{state | long_counter: Counter.init()}
    {:noreply, state}
  end

  defp short_interval do
    Application.get_env(:belfrage, :short_counter_reset_interval)
  end

  defp long_interval do
    Application.get_env(:belfrage, :long_counter_reset_interval)
  end
end
