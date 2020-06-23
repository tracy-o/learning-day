defmodule Belfrage.DialsManager do
  @moduledoc false

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
end
