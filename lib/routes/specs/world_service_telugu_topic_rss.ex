defmodule Routes.Specs.WorldServiceTeluguTopicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"],
        examples: [
          %{
            path: "/telugu/topics/c5qvp16w7dnt/rss.xml",
            headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
