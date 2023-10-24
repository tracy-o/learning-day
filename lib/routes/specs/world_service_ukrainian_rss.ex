defmodule Routes.Specs.WorldServiceUkrainianRss do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: [
          %{
            path: "/ukrainian/ukraine_in_russian/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          },
          %{
            path: "/ukrainian/in_depth/cluster_rio_olympics/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
