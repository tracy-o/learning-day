defmodule Belfrage.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    recompile_routefile()
    :ok = Belfrage.Metrics.Statix.connect()
    Belfrage.Supervisor.start_link(args)
  end

  # for "only_on" routes
  # route file already built for live production environment
  # only need to recompile on test
  defp recompile_routefile("test") do
    Application.put_env(:belfrage, :production_environment, "live")
    Code.compile_file(@routefile_location)
    Application.put_env(:belfrage, :production_environment, "test")
  end

  defp recompile_routefile(_), do: :noop
end
