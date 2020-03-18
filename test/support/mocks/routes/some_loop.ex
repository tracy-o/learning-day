defmodule Routes.Specs.SomeLoop do
  def specs do
    %{
      owner: "Some guy",
      runbook: "Some runbook",
      platform: Webcore,
      pipeline: ["LambdaOriginAlias"],
      query_params_allowlist: ["query"],
      resp_pipeline: []
    }
  end
end
