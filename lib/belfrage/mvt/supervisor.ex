defmodule Belfrage.Mvt.Supervisor do
  use Supervisor, restart: :temporary

  alias Belfrage.Mvt.{FilePoller, Slots}

  def start_link(opts \\ nil) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    Supervisor.init(children(opts), strategy: :one_for_one, max_restarts: 40)
  end

  defp children(opts) do
    if Keyword.get(opts, :env) in [:dev, :test] do
      [Slots]
    else
      [Slots, FilePoller]
    end
  end
end
