defmodule Routes.Specs.WorldServiceRussianRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/russian/science/rss.xml", "/russian/indepth/mh17_ukraine/rss.xml"]
      }
    }
  end
end
