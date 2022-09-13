defmodule Routes.Specs.TopicRss do
  def specs(env) do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Fabl,
      pipeline: pipeline(env)
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "RssFeedRedirect", "TopicRssFeeds", "AppPersonalisation", "Personalisation", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
