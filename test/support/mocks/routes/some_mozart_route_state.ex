defmodule Routes.Specs.SomeMozartRouteState do
  def specs do
    %{
      owner: "An owner",
      runbook: "Some runbook",
      platform: MozartNews,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector"],
      query_params_allowlist: ["page"]
    }
  end
end
