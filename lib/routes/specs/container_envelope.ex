defmodule Routes.Specs.ContainerEnvelope do
  def specs(production_env) do
    %{
      owner: "d&ewebcorepresentationteam@bbc.co.uk",
      platform: Webcore,
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/Presentation+Layer+Run+Book#PresentationLayerRunBook-ContainerAPI",
      query_params_allowlist: ["static"],
      pipeline: pipeline(production_env)
    } # TODO: Add something (query string requirement?) that indicates this catch-all shouldn't be used in production
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "UserAgentValidator", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
