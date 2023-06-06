defmodule Routes.Specs.NewsStorytellingPage do
  def specs do
    [
      %{
        owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
        platform: "Webcore",
        request_pipeline: ["ObitMode"]
      },
      %{
        platform: "BBCX"
      }
    ]
  end

  def preflight_pipeline do
    ["BBCXPlatformSelector"]
  end
end
