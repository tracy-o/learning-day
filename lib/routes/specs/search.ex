defmodule Routes.Specs.Search do
  def specs do
    %{
      owner: "natalia.miller@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
      platform: :webcore,
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias", "CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100,
      query_params_allowlist: ["q", "page", "scope", "filter"]
    }
  end
end
