defmodule Routes.Specs.HomePagePersonalised do
  def specs(production_env) do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
      platform: Webcore,
      pipeline: pipeline(production_env),
      cookie_allowlist: ["ckns_atkn", "ckns_id"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
