defmodule Routes.Specs.WorldServiceSwahiliTopicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"],
        examples: [
          %{
            path: "/swahili/topics/c06gq663n6jt/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
