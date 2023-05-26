defmodule Routes.Platforms.BBCX do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :bbcx_endpoint),
      owner: "GnlDevOps@bbc.com",
      runbook: "TBD",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: [],
      circuit_breaker_error_threshold: 200
    }
  end

  defp pipeline("live"), do: ["BBCXAuth", :_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
