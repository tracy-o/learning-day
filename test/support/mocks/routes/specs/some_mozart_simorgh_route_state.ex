defmodule Routes.Specs.SomeMozartSimorghRouteState do
  def specification do
    %{
      specs: %{
        owner: "An owner",
        runbook: "Some runbook",
        platform: "MozartSimorgh",
        query_params_allowlist: ["page"]
      }
    }
  end
end
