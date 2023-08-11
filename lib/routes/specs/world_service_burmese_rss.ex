defmodule Routes.Specs.WorldServiceBurmeseRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/burmese/in_depth/rss.xml", "/burmese/specials/olympics_rio_2016/rss.xml"]
      }
    }
  end
end
