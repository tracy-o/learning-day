defmodule Routes.Specs.WorldServicePortugueseRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/portuguese/internacional/rss.xml", "/portuguese/especiais/cluster_zika/rss.xml"]
      }
    }
  end
end
