defmodule Routes.Specs.WorldServicePersianRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: [
          %{
            path: "/persian/tv-and-radio-37434376/rss.xml",
            headers: %{"host" => "feeds.bbci.co.uk"}
          },
          %{
            path: "/persian/indepth/cluster_ptv_click/rss.xml",
            headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
