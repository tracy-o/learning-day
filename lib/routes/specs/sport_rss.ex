defmodule Routes.Specs.SportRss do
  def specs do
    %{
      owner: "#help-sport",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Karanga,
      pipeline: ["RssFeedRedirect", "SportTopicRssFeedsPlatformDiscriminator"]
    }
  end
end
