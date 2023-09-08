defmodule Routes.Specs.WorldServiceSerbianRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/serbian/lat/front_page/rss.xml", "/serbian/cyr/front_page/rss.xml"]
      }
    }
  end
end
