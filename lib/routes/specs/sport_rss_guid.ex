defmodule Routes.Specs.SportRssGuid do
  def specs do
    %{
      owner: "#help-sport",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: Karanga,
      request_pipeline: ["RssFeedRedirect", "SportGuidRssFeedsPlatformDiscriminator"]
    }
  end
end
