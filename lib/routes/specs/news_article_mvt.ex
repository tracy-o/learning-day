defmodule Routes.Specs.NewsArticleMvt do
  def specs do
    %{
      owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
      platform: Webcore,
      mvt_project_id: 1,
      request_pipeline: ["ObitMode"]
    }
  end
end
