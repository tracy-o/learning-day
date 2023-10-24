defmodule Routes.Platforms.DotComNewsletters do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :dotcom_newsletters_endpoint),
      email: "GnlDevOps@bbc.com",
      runbook: "https://confluence.dev.bbc.co.uk/display/bbccom/BBC.com+Newsletters",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      headers_allowlist: ["cookie-ckns_bbccom_beta"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200
    }
  end

  defp query_params_allowlist(_production_env) do
    ["ads-debug", "ads-test", "content_rec", "force-client-flagpoles", "googfc", "google_preview", "ias_publisher", "measure-performance", "mode", "page", "permutive", "piano-debug", "ptrt", "sequenced-loading", "uid", "userOrigin", "vpid"]
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "IsCommercial", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]

end
