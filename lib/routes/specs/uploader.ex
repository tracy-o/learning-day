defmodule Routes.Specs.Uploader do
  def specs(production_env) do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=183485635",
      platform: Webcore,
      pipeline: pipeline(production_env),
      personalisation: "on"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
