defmodule Routes.Specs.SportDisciplineTeamTopic do
  def specs(production_env) do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: Webcore,
      query_params_allowlist: query_params_allowlist(production_env),
      pipeline: pipeline(production_env),
      cookie_allowlist: cookie_allowlist(production_env),
      headers_allowlist: headers_allowlist(production_env)
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["page", "personalisationMode"]

  defp cookie_allowlist("live"), do: []
  defp cookie_allowlist(_production_env), do: ["ckns_atkn", "ckns_id"]

  defp headers_allowlist("live"), do: []
  defp headers_allowlist(_production_env), do: ["x-id-oidc-signedin"]

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "UserSession", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
