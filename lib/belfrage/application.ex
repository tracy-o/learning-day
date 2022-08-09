defmodule Belfrage.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    Belfrage.Xray.Telemetry.setup()
    Belfrage.Supervisor.start_link(args)
  end
end
