defmodule Routes.Specs.FablData do
  def specs do
    %{
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
      platform: :fabl,
      pipeline: ["HTTPredirect", "CircuitBreaker"],
      resp_pipeline: [],
      query_params_allowlist: "*",
      circuit_breaker_error_threshold: 100
    }
  end
end
