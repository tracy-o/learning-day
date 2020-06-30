defmodule Belfrage.DialsSupervisor do
  @moduledoc false

  # dial GenServers that observe and react to dials change event
  @dials [Belfrage.Dials.CircuitBreaker]

  @type dials_event :: :dials_changed

  @doc """
  Starts a dials event supervisor.

  This is the minimal event supervisor recommended by Elixir
  (alternative to the deprecated `GenEvent`). It is
  responsible for managing dials, publishing dials changed
  event and notifying observers (dial GenServers).
  """
  @spec start_link() :: Supervisor.on_start()
  def start_link() do
    # TODO: use `Supervisor` in https://jira.dev.bbc.co.uk/browse/RESFRAME-3592
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  @doc """
  Create and add a dial (observer) to the dials supervision tree.

  A dial observer is a GenServer that represents a Cosmos dial in Belfrage.
  It receives/handles event notification, keeps a formatted
  dial state and provides a dedicated message queue.
  """
  @spec add_dial(module, list) :: DynamicSupervisor.on_start_child()
  def add_dial(dial, opts) do
    DynamicSupervisor.start_child(__MODULE__, {dial, opts})
  end

  @doc """
  Add dials to the supervision tree.
  """
  @spec add_dials(list) :: no_return()
  def add_dials(dials \\ @dials) do
    Enum.each(dials, &add_dial(&1, []))
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
end
