defmodule Routes.Specs.WorldServiceSinhalaRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/sinhala/world-37926046/rss.xml", "/sinhala/sport/kumar_sangakkara_cricket/rss.xml"]
      }
    }
  end
end
