defmodule Routes.Specs.SomeMozartSportRouteState do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "MozartSport",
        query_params_allowlist: ["page"]
      }
    }
  end
end
