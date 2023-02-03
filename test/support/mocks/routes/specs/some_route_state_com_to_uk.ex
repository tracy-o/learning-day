defmodule Routes.Specs.SomeRouteStateComToUK do
  def specs do
    %{
      owner: "Some person",
      runbook: "Some runbook",
      platform: "Webcore",
      request_pipeline: ["ComToUKRedirect"],
      query_params_allowlist: ["q", "page", "scope", "filter"]
    }
  end
end
