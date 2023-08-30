defmodule Routes.Platforms.DotComReel do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :dotcom_reel_endpoint),
      owner: "GnlDevOps@bbc.com",
      runbook: "https://confluence.dev.bbc.co.uk/display/bbccom/BBC+Reel+Runbook",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200
    }
  end

  defp query_params_allowlist(_production_env) do
    ["itemsPerPage", "mode", "page", "vpid"]
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
