defmodule Ingress.Guardian do
  use GenServer, restart: :temporary

  alias Ingress.{Counter, HandlersCache, HandlersRegistry}

  @threshold Application.get_env(:ingress, :guardian_threshold)
  @interval  Application.get_env(:ingress, :guardian_interval)
  @origin    Application.get_env(:ingress, :origin)
  @fallback  Application.get_env(:ingress, :fallback)

  def start_link(name) do
    IO.puts("Startinng handler for #{name}")
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def origin(name) do
    HandlersCache.lookup(name)
  end

  def inc(name, http_status) do
    GenServer.cast(via_tuple(name), {:inc, http_status})
  end

  defp via_tuple(name) do
    HandlersRegistry.via_tuple({__MODULE__, name})
  end

  # callbacks

  @impl GenServer
  def init(_) do
    Process.send_after(self(), :reset, @interval)
    {:ok, _} = HandlersCache.put(Ingress.HandlersCache, "handler", @origin)

    {:ok, %{counter: Counter.init, tripped: false}}
  end

  @impl GenServer
  def handle_cast({:inc, http_status}, state) do
    state    = %{state | counter: Counter.inc(state.counter, http_status)}
    exceed   = Counter.exceed?(state.counter, :errors, @threshold)
    {:ok, _} = HandlersCache.put(Ingress.HandlersCache, "handler", origin_pointer(exceed))

    {:noreply, state}
  end

  # Resets the counter at every window.
  # TODO: Before resetting it should send
  # the counter to the Controller app.
  @impl GenServer
  def handle_info(:reset, state) do
    Process.send_after(self(), :reset, @interval)
    state = %{state | counter: Counter.init}
    {:ok, _} = HandlersCache.put(Ingress.HandlersCache, "handler", @origin)

    {:noreply, state}
  end

  defp origin_pointer(false), do: @origin
  defp origin_pointer(true),  do: @fallback
end
