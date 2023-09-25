defmodule Routes.Specs.WorldServicePunjabiHomePageRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "WorldServiceTopicRssFeedsMapper"],
        examples: [
          %{
            path: "/punjabi/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
