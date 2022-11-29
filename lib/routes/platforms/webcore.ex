defmodule Routes.Platforms.Webcore do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :pwa_lambda_function),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "CustomRssErrorResponse", "PreCacheCompression"],
      circuit_breaker_error_threshold: 200,
      query_params_allowlist: query_params_allowlist(production_env),
      mvt_project_id: 1
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["mode", "chameleon", "mvt", "renderer_env", "toggles", "experiments"]

  defp pipeline("live") do
    [:_routespec_pipeline_placeholder, "Personalisation", "LambdaOriginAlias", "Language", "PlatformKillSwitch", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
