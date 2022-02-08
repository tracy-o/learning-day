defmodule Belfrage.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    :ok = Belfrage.Metrics.Statix.connect()
    Belfrage.Xray.Telemetry.setup()
    Belfrage.Supervisor.start_link(args)
  end
end
