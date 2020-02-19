defmodule Routes.Specs.SportFrontPage do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :pal,
      pipeline: ["HTTPredirect", "SportPal", "CircuitBreaker"],
      resp_pipeline: [],
      query_params_allowlist: ["show-service-calls"],
      circuit_breaker_error_threshold: 100
    }
  end
end
