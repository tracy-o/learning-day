defmodule Routes.Specs.WorldServiceZhongwenRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/zhongwen/simp/science/rss.xml", "/zhongwen/simp/indepth/cluster_tianjin_blast/rss.xml", "/zhongwen/trad/science/rss.xml", "/zhongwen/trad/indepth/cluster_us_elect_2016/rss.xml"]
      }
    }
  end
end
