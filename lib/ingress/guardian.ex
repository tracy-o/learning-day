defmodule Ingress.Guardian do
  use GenServer

  alias Ingress.{Counter, HandlersCache}

  @threshold Application.get_env(:ingress, :guardian_threshold)
  @interval  Application.get_env(:ingress, :guardian_interval)
  @origin    Application.get_env(:ingress, :origin)
  @fallback  Application.get_env(:ingress, :fallback)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :guardian)
  end

  def origin(_server) do
    HandlersCache.lookup("handler")
  end

  def inc(server, http_status) do
    GenServer.cast(server, {:inc, http_status})
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
