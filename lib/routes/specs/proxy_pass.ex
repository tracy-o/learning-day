defmodule Routes.Specs.ProxyPass do
  def specs do
    %{
      owner: "belfrage-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :origin_simulator,
      pipeline: ["CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 2
    }
  end
end
