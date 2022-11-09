defmodule Routes.Specs.SportTopicRss do
  def specs do
    %{
      owner: "#help-sport",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Fabl,
      request_pipeline: ["RssFeedRedirect", "SportTopicRssFeedsMapper"]
    }
  end
end
