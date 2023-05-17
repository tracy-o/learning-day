defmodule Routes.Specs.NewsArticleMvt do
  def specification do
    %{
      preflight_pipeline: ["BBCXPlatformSelector"],
      specs: [
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
    }
  end
end
