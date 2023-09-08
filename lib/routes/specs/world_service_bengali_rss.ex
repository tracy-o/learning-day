defmodule Routes.Specs.WorldServiceBengaliRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/bengali/news-51941294/rss.xml", "/bengali/in_depth/bbc_probaho_tv/rss.xml"]
      }
    }
  end
end
