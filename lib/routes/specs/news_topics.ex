defmodule Routes.Specs.NewsTopics do
  def specs(production_env) do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: MozartNews,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["page"]
    }
  end

  defp pipeline("live") do 
    ["HTTPredirect", "TrailingSlashRedirector", "NewsTopicsPlatformDiscriminator", "CircuitBreaker"]
  end
 
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
