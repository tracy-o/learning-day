defmodule Belfrage.Mvt.Supervisor do
  use Supervisor

  alias Belfrage.Mvt.{FilePoller, Slots}

  def start_link(opts \\ nil) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    Supervisor.init(children(opts), strategy: :one_for_one, max_restarts: 40)
  end

  defp children(opts) do
    case Keyword.get(opts, :env) do
      :test -> [Slots]
      _env -> [FilePoller, Slots]
    end
  end
end
