defmodule Routes.Specs.SomeMozartRouteState do
  def specification do
    %{
      specs: %{
        owner: "An owner",
        runbook: "Some runbook",
        platform: "MozartNews",
        query_params_allowlist: ["page"]
      }
    }
  end
end
