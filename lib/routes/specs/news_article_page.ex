defmodule Routes.Specs.NewsArticlePage do
  def specs do
    %{
      owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
      platform: Webcore,
      circuit_breaker_error_threshold: 1_000,
      pipeline: ["ProxyOnJoan", "NewsArticleValidator", "ObitMode", "ElectionBannerCouncilStory", "ElectionBannerNiStory"]
    }
  end
end
