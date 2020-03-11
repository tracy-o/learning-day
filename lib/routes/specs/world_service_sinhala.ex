defmodule Routes.Specs.WorldServiceSinhala do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      platform: :mozart,
      pipeline: ["WorldServiceRedirect", "CircuitBreaker"],
      resp_pipeline: [],
      query_params_allowlist: ["alternativeJsLoading", "batch"],
      circuit_breaker_error_threshold: 100
    }
  end
end
