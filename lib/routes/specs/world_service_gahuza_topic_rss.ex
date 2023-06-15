defmodule Routes.Specs.WorldServiceGahuzaTopicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"],
        examples: ["/gahuza/topics/c7zp5z0yd0xt/rss.xml"]
      }
    }
  end
end
