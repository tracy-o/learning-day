defmodule Routes.Specs.SomeMozartWeatherRouteState do
  def specification do
    %{
      specs: %{
        owner: "An owner",
        runbook: "Some runbook",
        platform: "MozartWeather",
        query_params_allowlist: ["page"]
      }
    }
  end
end
