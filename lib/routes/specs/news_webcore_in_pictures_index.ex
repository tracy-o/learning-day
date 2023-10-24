defmodule Routes.Specs.NewsWebcoreInPicturesIndex do
  def specification do
    %{
      preflight_pipeline: ["BBCXWebcorePlatformSelector"],
      specs: [
        %{
          email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
          platform: "Webcore",
          examples: ["/news/in_pictures"]
        },
        %{
          platform: "BBCX",
          examples: ["/news/in_pictures"]
        }
      ]
    }
  end
end