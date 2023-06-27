defmodule Routes.Platforms.MozartSport do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :mozart_sport_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", :_routespec_pipeline_placeholder, "ResponseHeaderGuardian", "PreCacheCompression"],
      headers_allowlist: headers_allowlist(production_env),
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200
    }
  end

  defp headers_allowlist("live"), do: []
  defp headers_allowlist(_production_env), do: ["cookie-ckns_bbccom_beta"]

  defp query_params_allowlist("live"), do: ["alternativeJsLoading", "amp", "batch", "before", "category_site", "component_id", "components", "config_path", "embeddingPageTitle", "embeddingPageUri", "lang", "options", "page", "presenter", "ptrt", "q", "redirect_location", "s", "search", "show-service-calls", "start", "ticker", "anchor"]
  defp query_params_allowlist(_production_env), do: "*"

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "IsCommercial", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
