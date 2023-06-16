defmodule Routes.Specs.WorldServiceAfaanoromooTopicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"],
        examples: ["/afaanoromoo/topics/c7zp5z9n3x5t/rss.xml"]
      }
    }
  end
end
