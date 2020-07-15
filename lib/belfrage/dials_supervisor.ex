defmodule Belfrage.DialsSupervisor do
  @moduledoc false

  use Supervisor
  alias Belfrage.Dials

  @dials [Dials.CircuitBreaker, Dials.TtlMultiplier]

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
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  Create and add dials to the supervision tree.

  A dial observer is a GenServer that represents a Cosmos dial in Belfrage.
  It receives/handles event notification, keeps a formatted
  dial state and provides a dedicated message queue.
  """
  @impl true
  def init(_init_arg) do
    children = dial_children() ++ [Belfrage.Dials.Poller]
    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Notify dials of an dial update event.
  """
  @spec notify(dials_event, map) :: :ok
  def notify(:dials_changed, dials_data) do
    for dial <- @dials do
      GenServer.cast(dial, {:dials_changed, dials_data})
    end
  end

  @spec dials() :: [atom()]
  def dials, do: @dials

  defp dial_children do
    Enum.map(@dials, fn dial_mod ->
      opts = [dial: dial_mod, name: String.to_atom(dial_mod.name())]
      Supervisor.child_spec({Belfrage.Dial, opts}, id: dial_mod.name())
    end)
  end
end
