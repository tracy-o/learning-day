defmodule Routes.Specs.WorldServiceArabicTopicRss do
  def specs(env) do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Fabl,
      request_pipeline: pipeline(env)
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "RssFeedDomainValidator", "TopicRssFeeds", "AppPersonalisation", "Personalisation", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
