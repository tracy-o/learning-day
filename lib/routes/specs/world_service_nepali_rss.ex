defmodule Routes.Specs.WorldServiceNepaliRss do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: [
          %{
            path: "/nepali/news-51941128/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          },
          %{
            path: "/nepali/news/constitution_cluster/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
