defmodule Routes.Specs.WorldServiceNepaliRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/nepali/news-51941128/rss.xml", "/nepali/news/constitution_cluster/rss.xml"]
      }
    }
  end
end
