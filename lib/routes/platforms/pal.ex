defmodule Routes.Platforms.Pal do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: ["HTTPredirect", "CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100
    }
  end
end
