defmodule Belfrage.Dials.Supervisor do
  use Supervisor, restart: :temporary

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Supervisor.init([Belfrage.Dials.State], strategy: :one_for_one, max_restarts: 40)
  end
end
