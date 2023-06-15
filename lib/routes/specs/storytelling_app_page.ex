defmodule Routes.Specs.StorytellingAppPage do
  def specification do
    %{
      specs: %{
        owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
        platform: "Webcore",
        request_pipeline: ["ObitMode"],
        examples: ["/articles/c1vy1zrejnno.app"]
      }
    }
  end
end
