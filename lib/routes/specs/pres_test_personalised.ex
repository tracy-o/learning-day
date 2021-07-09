defmodule Routes.Specs.PresTestPersonalised do
  def specs(production_env) do
    %{
      owner: "D&EWebCorePresentationTeam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["q", "page", "scope", "filter", "personalisationMode"],
      pipeline: pipeline(production_env),
      personalisation: "on"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
