defmodule Routes.Specs.NewsTopics do
  def specs do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: Mozart,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector", "NewsTopicsPlatformDiscriminator", "LambdaOriginAlias", "CircuitBreaker", "Language"],
      query_params_allowlist: ["page"]
    }
  end
end
