defmodule Routes.Specs.SportDisciplineCompetitionTopic do
  def specs(production_env) do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: Webcore,
      query_params_allowlist: ["page"],
      pipeline: pipeline(production_env),
      cookie_allowlist: cookie_allowlist(production_env),
      headers_allowlist: headers_allowlist(production_env)
    }
  end

  defp cookie_allowlist("live"), do: []
  defp cookie_allowlist(_production_env), do: ["ckns_atkn", "ckns_id"]

  defp headers_allowlist("live"), do: []
  defp headers_allowlist(_production_env), do: ["x-id-oidc-signedin"]

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests", "UserSession"]
end
