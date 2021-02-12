defmodule Routes.Specs.StorytellingPage do
  def specs do
    %{
      owner: "DEArticleReadingExperience@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART",
      platform: Webcore,
      circuit_breaker_error_threshold: 500
    }
  end
end
