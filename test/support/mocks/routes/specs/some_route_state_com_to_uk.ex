defmodule Routes.Specs.SomeRouteStateComToUK do
  def specification do
    %{
      specs: %{
        owner: "Some person",
        runbook: "Some runbook",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"],
        query_params_allowlist: ["q", "page", "scope", "filter"]
      }
    }
  end
end
