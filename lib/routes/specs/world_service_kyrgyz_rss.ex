defmodule Routes.Specs.WorldServiceKyrgyzRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/kyrgyz/kyrgyzstan/rss.xml", "/kyrgyz/world/women_in_sport/rss.xml"]
      }
    }
  end
end
