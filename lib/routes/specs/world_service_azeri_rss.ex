defmodule Routes.Specs.WorldServiceAzeriRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/azeri/international/rss.xml", "/azeri/international/rio_2016/rss.xml"]
      }
    }
  end
end
