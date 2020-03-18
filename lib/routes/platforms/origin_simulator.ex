defmodule Routes.Platforms.OriginSimulator do
  def specs do
    %{
      owner: "belfrage-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: ["CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100
    }
  end
end
