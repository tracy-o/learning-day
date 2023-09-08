defmodule Routes.Specs.WorldServiceArabicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/arabic/scienceandtech/rss.xml", "/arabic/indepth/prog_arabic_main/rss.xml"]
      }
    }
  end
end
