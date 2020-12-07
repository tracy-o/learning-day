defmodule Routes.Specs.SomeMozartLoop do
  def specs do
    %{
      owner: "An owner",
      runbook: "Some runbook",
      platform: Mozart,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector"],
      query_params_allowlist: ["page"]
    }
  end
end
