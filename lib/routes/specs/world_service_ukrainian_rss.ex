defmodule Routes.Specs.WorldServiceUkrainianRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/ukrainian/ukraine_in_russian/rss.xml", "/ukrainian/in_depth/cluster_rio_olympics/rss.xml"]
      }
    }
  end
end
