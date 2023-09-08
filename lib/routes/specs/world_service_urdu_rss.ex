defmodule Routes.Specs.WorldServiceUrduRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/urdu/world/rss.xml", "/urdu/indepth/pakistan_budget_2016_zs/rss.xml"]
      }
    }
  end
end
