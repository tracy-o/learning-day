defmodule Routes.Platforms.Programmes do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :programmes_endpoint),
      email: "homedatacap@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", :_routespec_pipeline_placeholder, "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 800
    }
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]

  defp query_params_allowlist(_production_env) do
    ["page", "limit", "preview", "noorb", "__2016minimap", "nestedlevel", "utcoffset", "no_chrome", "partial", "callback", "branding_context", "service", "__flush_cache", "branding-theme-version", "xtor", "at_campaign", "at_medium", "at_custom1", "at_custom2", "at_custom3", "at_custom4", "__scenario_time", "__scenario", "__generate", "__regenerate"]
  end
end
