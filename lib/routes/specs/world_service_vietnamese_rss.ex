defmodule Routes.Specs.WorldServiceVietnameseRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/vietnamese/in-depth-43037169/rss.xml", "/vietnamese/indepth/euro_france_2016/rss.xml"]
      }
    }
  end
end
