defmodule Routes.Specs.WorldServiceAfriqueHomePageRss do
  def specs do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Karanga,
      request_pipeline: ["RssFeedRedirect"]
    }
  end
end
