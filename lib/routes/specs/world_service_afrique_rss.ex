defmodule Routes.Specs.WorldServiceAfriqueRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: [
          %{
            path: "/afrique/sports-38506183/rss.xml",
            headers: %{"host" => "feeds.bbci.co.uk"}
          },
          %{
            path: "/afrique/region/guinea_elections/rss.xml",
            headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
