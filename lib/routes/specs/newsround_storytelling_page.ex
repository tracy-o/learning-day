defmodule Routes.Specs.NewsroundStorytellingPage do
  def specification do
    %{
      specs: %{
        owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
        platform: "Webcore",
        request_pipeline: ["ObitMode"],
        examples: ["/newsround/articles/c3gv75nj0mzo"]
      }
    }
  end
end
