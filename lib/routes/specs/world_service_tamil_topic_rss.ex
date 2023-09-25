defmodule Routes.Specs.WorldServiceTamilTopicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"],
        examples: [
          %{
            path: "/tamil/topics/c06gq6gnzdgt/rss.xml",
            headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
