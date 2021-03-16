defmodule Routes.Specs.MySessionWebcorePlatform do
  def specs(production_env) do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: Webcore,
      pipeline: pipeline(production_env),
      cookie_allowlist: ["ckns_atkn"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "UserSession", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
