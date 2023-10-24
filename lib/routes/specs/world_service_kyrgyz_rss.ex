defmodule Routes.Specs.WorldServiceKyrgyzRss do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: [
          %{
            path: "/kyrgyz/kyrgyzstan/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          },
          %{
            path: "/kyrgyz/world/women_in_sport/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
