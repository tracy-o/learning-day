defmodule Routes.Specs.SomeLoop do
  def specs do
    %{
      owner: "Some guy",
      runbook: "Some runbook",
      platform: Webcore,
      query_params_allowlist: ["query"]
    }
  end
end
