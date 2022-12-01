defmodule Belfrage.Dials.Supervisor do
  use Supervisor, restart: :temporary
  use Belfrage.DialConfig
  @type dials_event :: :dials_changed

  @doc """
  Starts a dials event supervisor.

  This is the minimal event supervisor recommended by Elixir
  (alternative to the deprecated `GenEvent`). It is
  responsible for managing dials, publishing dials changed
  event and notifying dial GenServers.
  """
  @spec start_link(list) :: Supervisor.on_start()
  def start_link(init_arg) do
    name = Keyword.get(init_arg, :name, __MODULE__)
    Supervisor.start_link(__MODULE__, init_arg, name: name)
  end

  @doc """
  Create and add dials to the supervision tree.

  A dial observer is a GenServer that represents a Cosmos dial in Belfrage.
  It receives/handles event notification, keeps a formatted
  dial state and provides a dedicated message queue.
  """
  @impl true
  def init(opts) do
    Supervisor.init(children(opts), strategy: :one_for_one, max_restarts: 40)
  end

  @doc """
  Notify dials of an dial update event.
  """
  @spec notify(dials_event, map) :: :ok
  def notify(:dials_changed, dials_data) do
    for {_dial_mod, dial_name, _default} <- dial_config() do
      GenServer.cast(dial_name, {:dials_changed, dials_data})
    end
  end

  defp children(opts) do
    if Keyword.get(opts, :env) in [:dev, :test] do
      dial_children()
    else
      dial_children() ++ [Belfrage.Dials.Poller]
    end
  end

  defp dial_children do
    Enum.map(dial_config(), fn dial_info = {_dial_mod, dial_name, _default_value} ->
      Supervisor.child_spec({Belfrage.Dials.LiveServer, dial_info}, id: dial_name)
    end)
  end
end
