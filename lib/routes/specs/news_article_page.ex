defmodule Routes.Specs.NewsArticlePage do
  def specs do
    %{
      owner: "DENewsCardiff@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
      platform: Webcore,
      circuit_breaker_error_threshold: 500,
      pipeline: ["ProxyOnJoan", "NewsArticleValidator", "ElectionBannerCouncilStory", "ElectionBannerNiStory"]
    }
  end
end
