defmodule Routes.Specs.NewsAmp do
  def specs(production_env) do
    %{
      owner: "WorldServiceSharedTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Simorgh+Run+Book",
      platform: Simorgh,
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
