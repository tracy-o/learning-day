defmodule Belfrage.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    recompile_routefile()
    :ok = Belfrage.Metrics.Statix.connect()
    Belfrage.Supervisor.start_link(args)
  end

  # `production_environment` config value is used when defining routes with an
  # `only_on` attribute. Routes are defined at compile time and
  # `production_environment` is configured via an ENV variable at runtime,
  # which means that the runtime value can be different to what was used during
  # compilation and it's possible that a route that is supposed to be present
  # in the current env hasn't been defined at compile time.
  #
  # In practice, this only matters when deploying test instances of Belfrage:
  # the code is compiled with `production_environment` set to "live" and then
  # it's run with the value set to "test" and so routes with `only_on: :test`
  # aren't defined. To fix this we recompile the routefile when starting the
  # app if `production_enviroment` is `test`.
  #
  # We don't need to do this when running tests though:
  # `production_environment` is set to "test" during compilation when tests are
  # run, so the routefile is compiled correctly.
  defp recompile_routefile() do
    production_env = Application.get_env(:belfrage, :production_environment)
    test_envs = ~w(test end_to_end routes_test smoke_test)a

    if production_env == "test" && Mix.env() not in test_envs do
      :belfrage
      |> Application.get_env(:routefile_location)
      |> Code.compile_file()
    end
  end
end
