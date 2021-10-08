defmodule Routes.Specs.ContainerEnvelopeTestContainers do
  def specs(production_env) do
    %{
      owner: "d&ewebcorepresentationteam@bbc.co.uk",
      platform: Webcore,
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/Presentation+Layer+Run+Book#PresentationLayerRunBook-ContainerAPI",
      query_params_allowlist: ["q", "page", "scope", "filter", "static"],
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "UserAgentValidator", "Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Chameleon", "Language"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
