defmodule Routes.Specs.SomeMozartSportRouteState do
  def specification do
    %{
      specs: %{
        owner: "An owner",
        runbook: "Some runbook",
        platform: "MozartSport",
        query_params_allowlist: ["page"]
      }
    }
  end
end
