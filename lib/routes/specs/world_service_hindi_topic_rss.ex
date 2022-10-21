defmodule Routes.Specs.WorldServiceHindiTopicRss do
  def specs do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Fabl,
      request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"]
    }
  end
end