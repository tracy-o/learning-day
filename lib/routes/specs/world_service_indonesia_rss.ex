defmodule Routes.Specs.WorldServiceIndonesiaRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/indonesia/majalah/rss.xml", "/indonesia/laporan_khusus/lapsus_fobia_komunis/rss.xml"]
      }
    }
  end
end
