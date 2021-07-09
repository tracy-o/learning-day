defmodule Routes.Specs.NewsTopics do
  def specs(production_env) do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: MozartNews,
      query_params_allowlist: ["page"],
      pipeline: pipeline(production_env),
      personalisation: "test_only"
    }
  end

  defp pipeline("live") do 
    ["HTTPredirect", "TrailingSlashRedirector", "NewsTopicsPlatformDiscriminator", "CircuitBreaker"]
  end
 
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests", "Personalisation"]
end
