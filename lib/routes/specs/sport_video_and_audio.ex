defmodule Routes.Specs.SportVideoAndAudio do
  def specs(production_env) do
    %{
      owner: "sfv-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: MozartSport,
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "SportVideosPlatformDiscriminator", "CircuitBreaker"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
