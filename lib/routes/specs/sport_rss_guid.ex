defmodule Routes.Specs.SportRssGuid do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedRedirect", "SportGuidRssFeedsPlatformDiscriminator"],
        examples: [
          %{
            path: "/sport/football/rss.xml",
            request_headers: %{"host" => "feeds.bbci.co.uk"}
          }
        ]
      }
    }
  end
end
