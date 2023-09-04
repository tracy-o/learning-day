defmodule Routes.Specs.WorldServiceSwahiliRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/swahili/habari-53516858/rss.xml", "/swahili/michezo/caf_2013/rss.xml"]
      }
    }
  end
end
