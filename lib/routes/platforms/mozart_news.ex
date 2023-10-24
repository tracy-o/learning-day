defmodule Routes.Platforms.MozartNews do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :mozart_news_endpoint),
      email: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      headers_allowlist: ["cookie-ckns_bbccom_beta"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env) do
    ["ads-debug", "component_env", "country", "edition", "mode", "morph_env", "prominence", "renderer_env", "use_fixture"]
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "IsCommercial", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
