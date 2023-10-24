defmodule Routes.Specs.SomeMozartRouteState do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "MozartNews",
        query_params_allowlist: ["page"]
      }
    }
  end
end
