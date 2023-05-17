defmodule Routes.Platforms.DotComCulture do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :dotcom_culture_endpoint),
      owner: "GnlDevOps@bbc.com",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=276265727",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: "*"

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
