defmodule Routes.Platforms.OriginSimulator do
  def specs(_production_env) do
    %{
      origin: Application.get_env(:belfrage, :origin_simulator),
      owner: "belfrage-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      request_pipeline: [:_routespec_pipeline_placeholder, "CircuitBreaker"],
      response_pipeline: ["CacheDirective", :_routespec_pipeline_placeholder, "ResponseHeaderGuardian", "PreCacheCompression"],
      circuit_breaker_error_threshold: 200
    }
  end
end
