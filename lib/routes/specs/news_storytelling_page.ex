defmodule Routes.Specs.NewsStorytellingPage do
  def specification do
    %{
      preflight_pipeline: ["BBCXWebcorePlatformSelector"],
      specs: [
        %{
          owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
          platform: "Webcore",
          request_pipeline: ["ObitMode"],
          examples: ["/news/articles/c5ll353v7y9o", "/news/articles/c8xxl4l3dzeo"]
        },
        %{
          platform: "BBCX",
          examples: ["/news/articles/c5ll353v7y9o", "/news/articles/c8xxl4l3dzeo"]
        }
      ]
    }
  end
end
