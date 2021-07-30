defmodule Routes.Specs.PhoPublicContent do
  def specs(production_env) do
    %{
      owner: "#platform-health",
      platform: Webcore,
      pipeline: pipeline(production_env),
      personalisation: "off"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
