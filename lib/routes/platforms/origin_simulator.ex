defmodule Routes.Platforms.OriginSimulator do
  def specs(_production_env) do
    %{
      origin: Application.get_env(:belfrage, :origin_simulator),
      owner: "belfrage-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: ["CircuitBreaker"],
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "CustomRssErrorResponse"],
      circuit_breaker_error_threshold: 200
    }
  end
end
