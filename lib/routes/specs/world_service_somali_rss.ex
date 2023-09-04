defmodule Routes.Specs.WorldServiceSomaliRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/somali/war-41931340/rss.xml", "/somali/faaqidaad/nelsonnandela/rss.xml"]
      }
    }
  end
end
