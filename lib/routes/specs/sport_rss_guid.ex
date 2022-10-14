defmodule Routes.Specs.SportRssGuid do
  def specs do
    %{
      owner: "#help-sport",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Karanga,
      request_pipeline: ["RssFeedRedirect", "SportGuidRssFeedsPlatformDiscriminator"]
    }
  end
end
