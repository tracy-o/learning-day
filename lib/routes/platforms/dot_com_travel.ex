defmodule Routes.Platforms.DotComTravel do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :dotcom_travel_endpoint),
      email: "GnlDevOps@bbc.com",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=276265727",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200
    }
  end

  defp query_params_allowlist(_production_env) do
    ["ads-debug", "ads-test", "content_rec", "force-client-flagpoles", "googfc", "google_preview", "ias_publisher", "itemsPerPage", "measure-performance", "mode", "page", "permutive", "piano-debug", "ptrt", "sequenced-loading", "site", "uid", "userOrigin", "vpid"]
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
