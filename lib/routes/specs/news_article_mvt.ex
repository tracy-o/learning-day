defmodule Routes.Specs.NewsArticleMvt do
  def specs do
    %{
      owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
      platform: Webcore,
      circuit_breaker_error_threshold: 1_000,
      mvt_project_id: 1,
      request_pipeline: ["NewsArticleValidator", "ObitMode"]
    }
  end
end
