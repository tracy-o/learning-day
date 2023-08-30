defmodule Routes.Specs.WorldServiceGujaratiRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/gujarati/international-43405729/rss.xml", "/gujarati/front_page/rss.xml"]
      }
    }
  end
end
