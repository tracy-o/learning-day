defmodule Routes.Specs.HomePagePersonalised do
  def specs do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Runbook",
      platform: Webcore,
      query_params_allowlist: ["personalisationMode"],
      pipeline: ["UserSession"],
      cookie_allowlist: ["ckns_atkn", "ckns_id"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end
end
