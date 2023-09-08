defmodule Routes.Specs.WorldServiceTurkceRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/turkce/haberler-dunya-51801130/rss.xml", "/turkce/konular/turkey/rss.xml"]
      }
    }
  end
end
