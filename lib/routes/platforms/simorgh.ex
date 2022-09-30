defmodule Routes.Platforms.Simorgh do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :simorgh_endpoint),
      owner: "DENewsSimorghDev@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Simorgh+Run+Book",
      pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200,
      signature_keys: %{add: [:is_advertise], skip: [:country]}
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["component_env", "morph_env", "renderer_env"]

  defp pipeline("live"), do: ["HTTPredirect", "WorldServiceRedirect", :_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
