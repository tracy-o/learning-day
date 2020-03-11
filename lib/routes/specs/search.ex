defmodule Routes.Specs.Search do
  def specs do
    %{
      owner: "simon.scarfe@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias", "CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100,
      query_params_allowlist: ["q", "page", "scope", "filter"]
    }
  end
end
