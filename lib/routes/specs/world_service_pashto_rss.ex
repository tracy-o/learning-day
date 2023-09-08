defmodule Routes.Specs.WorldServicePashtoRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/pashto/afghanistan/rss.xml", "/pashto/in_depth/migration_special_page_iy/rss.xml"]
      }
    }
  end
end
