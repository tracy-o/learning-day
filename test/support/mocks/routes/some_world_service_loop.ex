defmodule Routes.Specs.SomeWorldServiceLoop do
  def specs do
    %{
      owner: "Some guy",
      runbook: "Some runbook",
      platform: Simorgh,
      pipeline: ["WorldServiceRedirect"],
      query_params_allowlist: ["query"],
      resp_pipeline: []
    }
  end
end
