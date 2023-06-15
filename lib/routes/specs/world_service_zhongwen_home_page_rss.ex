defmodule Routes.Specs.WorldServiceZhongwenHomePageRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/zhongwen/trad/rss.xml", "/zhongwen/simp/rss.xml"]
      }
    }
  end
end
