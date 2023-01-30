defmodule Belfrage.RouteSpecSupervisor do
  use Supervisor, restart: :temporary

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    Supervisor.init([{Belfrage.RouteSpecManager, opts}], strategy: :one_for_one, max_restarts: 40)
  end
end
