defmodule Belfrage.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    :ok = Belfrage.Metrics.Statix.connect()
    Belfrage.Supervisor.start_link(args)
  end
end
