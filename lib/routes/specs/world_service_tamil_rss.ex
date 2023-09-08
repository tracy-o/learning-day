defmodule Routes.Specs.WorldServiceTamilRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/tamil/india-51798836/rss.xml", "/tamil/india/oldageseriescluster/rss.xml"]
      }
    }
  end
end
