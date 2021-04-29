defmodule Belfrage.Application do
  @moduledoc false

  use Application

  @routefile_location Application.get_env(:belfrage, :routefile_location)

  def start(_type, args) do
    recompile_routefile(Application.get_env(:belfrage, :production_environment))
    :ok = Belfrage.Statix.connect()
    Belfrage.Supervisor.start_link(args)
  end

  # for "only_on" routes
  # route file already built for live production environment
  # only need to recompile on test
  defp recompile_routefile("test"), do: Code.compile_file(@routefile_location)
  defp recompile_routefile(_), do: :noop
end
