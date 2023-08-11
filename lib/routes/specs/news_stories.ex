defmodule Routes.Specs.NewsStoriesIndex do
  def specification do
    %{
      preflight_pipeline: ["BBCXWebcorePlatformSelector"],
      specs: [
        %{
          owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
          platform: "Webcore",
          examples: ["/news/stories"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end