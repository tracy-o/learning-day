defmodule Routes.Platforms.Fabl do
  def specs(_production_env) do
    %{
      origin: Application.get_env(:belfrage, :fabl_endpoint),
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
      pipeline: ["HTTPredirect", "CircuitBreaker"],
      resp_pipeline: [],
      query_params_allowlist: "*",
      circuit_breaker_error_threshold: 100
    }
  end
end
