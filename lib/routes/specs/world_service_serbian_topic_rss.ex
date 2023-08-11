defmodule Routes.Specs.WorldServiceSerbianTopicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"],
        examples: ["/serbian/lat/topics/c5wzvzzz5vrt/rss.xml", "/serbian/cyr/topics/cqwvxvvw9qrt/rss.xml"]
      }
    }
  end
end
