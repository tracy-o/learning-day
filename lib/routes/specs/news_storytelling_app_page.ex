defmodule Routes.Specs.NewsStorytellingAppPage do
  def specification do
    %{
      specs: %{
        email: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
        platform: "Webcore",
        request_pipeline: ["ObitMode"],
        examples: ["/news/articles/c5ll353v7y9o.app", "/news/articles/c8xxl4l3dzeo.app"]
      }
    }
  end
end
