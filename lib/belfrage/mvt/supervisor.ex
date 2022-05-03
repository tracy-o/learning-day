defmodule Belfrage.Mvt.Supervisor do
  use Supervisor

  alias Belfrage.Mvt.{FilePoller, Slots}

  def start_link(_arg \\ nil) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [FilePoller, Slots]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 40)
  end
end
