defmodule Routes.Platforms.Webcore do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :pwa_lambda_function),
      email: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "CustomRssErrorResponse", "PreCacheCompression"],
      circuit_breaker_error_threshold: 200,
      headers_allowlist: ["cookie-ckns_bbccom_beta"],
      query_params_allowlist: query_params_allowlist(production_env),
      mvt_project_id: 1,
      xray_enabled: true
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["mode", "chameleon", "mvt", "renderer_env", "toggles", "experiments"]

  defp pipeline("live") do
    ["SessionState", :_routespec_pipeline_placeholder, "PersonalisationGuardian", "LambdaOriginAlias", "Language", "PlatformKillSwitch", "IsCommercial", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
