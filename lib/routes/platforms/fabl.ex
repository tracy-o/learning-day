defmodule Routes.Platforms.Fabl do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :fabl_endpoint),
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "CustomRssErrorResponse", "PreCacheCompression"],
      query_params_allowlist: "*",
      headers_allowlist: headers_allowlist(production_env),
      circuit_breaker_error_threshold: 200,
      xray_enabled: true
    }
  end

  defp pipeline("live") do
    ["SessionState", :_routespec_pipeline_placeholder, "PersonalisationGuardian", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end

  defp headers_allowlist("test"), do: ["ctx-service-env"]
  defp headers_allowlist(_), do: []
end
