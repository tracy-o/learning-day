defmodule Routes.Specs.WorldServiceHausaRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/hausa/rahotanni/rss.xml", "/hausa/sport/cluster_bbcafoty/rss.xml"]
      }
    }
  end
end
