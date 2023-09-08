defmodule Routes.Specs.WorldServiceUzbekRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/uzbek/uzbekistan/rss.xml", "/uzbek/uzbekistan/uzbek_society/rss.xml"]
      }
    }
  end
end
