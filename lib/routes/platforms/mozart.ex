defmodule Routes.Platforms.Mozart do
  def specs("test") do
    %{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      pipeline: ["CircuitBreaker"],
      resp_pipeline: [],
      query_params_allowlist: "*",
      circuit_breaker_error_threshold: 100
    }
  end

  def specs(_production_env) do
    %{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      pipeline: ["CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100
    }
  end
end
