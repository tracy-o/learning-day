defmodule Routes.Specs.SomeRouteState do
  def specification do
    %{
      specs: %{
        owner: "Some guy",
        runbook: "Some runbook",
        platform: "Webcore",
        query_params_allowlist: ["query"]
      }
    }
  end
end
