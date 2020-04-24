defmodule Routes.Specs.AutomationHomePage do
  def specs do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Runbook",
      platform: Webcore,
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias", "CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100
    }
  end
end