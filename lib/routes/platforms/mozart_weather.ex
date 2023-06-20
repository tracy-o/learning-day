defmodule Routes.Platforms.MozartWeather do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :mozart_weather_endpoint),
      owner: "DEWeather@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=140399154",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", :_routespec_pipeline_placeholder, "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: query_params_allowlist(production_env),
      headers_allowlist: ["cookie-ckps_language", "cookie-ckns_bbccom_beta"],
      circuit_breaker_error_threshold: 200
    }
  end

  defp query_params_allowlist("live"), do: ["alternativeJsLoading", "amp", "batch", "before", "category_site", "component_id", "components", "config_path", "embeddingPageTitle", "embeddingPageUri", "lang", "options", "page", "presenter", "ptrt", "q", "redirect_location", "s", "search", "show-service-calls", "start", "ticker", "anchor"]
  defp query_params_allowlist(_production_env), do: "*"

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "IsCommercial", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
