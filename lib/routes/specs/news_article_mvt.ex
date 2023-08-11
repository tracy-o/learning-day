defmodule Routes.Specs.NewsArticleMvt do
  def specification do
    %{
      preflight_pipeline: ["BBCXWebcorePlatformSelector"],
      specs: [
        %{
          owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
          platform: "Webcore",
          request_pipeline: ["ObitMode"],
          examples: ["/news/articles/cn3zl2drk0ko", "/news/articles/cyxjrk98x59o", "/news/articles/ce5108j80gpo", "/news/articles/ce4xrgggdvgo"]
        },
        %{
          platform: "BBCX",
          examples: []
        }
      ]
    }
  end
end
