defmodule Belfrage.DialsManager do
  @moduledoc false

  # dial GenServers that observe and react to dials change event
  @dials [Belfrage.Dials.CircuitBreaker]

  @doc """
  Starts a dials event manager.

  This is the minimal supervisor-manager recommended by Elixir 
  (alternative to the deprecated `GenEvent`). It is 
  responsible for managing dials, publishing dials changed
  event and notifying observers (dial GenServers).
  """
  @spec start_link() :: Supervisor.on_start()
  def start_link() do
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  @doc """
  Adds a dial observer to the dials manager supervision tree.

  A dial observer is a GenServer that represents a Cosmos dial in Belfrage.
  It receives/handles event notification, keeps a formatted
  dial state and provide a dedicated message queue.
  """
  @spec add_handler(pid, module, list) :: DynamicSupervisor.on_start_child()
  def add_handler(manager, handler, opts) do
    DynamicSupervisor.start_child(manager, {handler, opts})
  end

  def register_dials(manager) do
    Enum.each(@dials, &add_handler(manager, &1, []))
  end
end
