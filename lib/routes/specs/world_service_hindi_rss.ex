defmodule Routes.Specs.WorldServiceHindiRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/hindi/science/rss.xml", "/hindi/indepth/malala_aj/rss.xml"]
      }
    }
  end
end