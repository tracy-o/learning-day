defmodule Routes.Specs.WorldServiceHindiHomePageRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: [
          %{
            path: "/hindi/rss.xml",
            headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
