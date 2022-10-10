defmodule Routes.Specs.NewsRss do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: Karanga,
      pipeline: ["RssFeedRedirect"]
    }
  end
end
