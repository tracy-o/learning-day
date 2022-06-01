defmodule Routes.Platforms.Simorgh do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :simorgh_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: pipeline(production_env),
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200,
      signature_keys: %{add: [:is_advertise], skip: [:country]}
    }
  end

  defp query_params_allowlist("live"), do: ["alternativeJsLoading", "amp", "batch", "before", "category_site", "component_id", "components", "config_path", "embeddingPageTitle", "embeddingPageUri", "id", "lang", "options", "presenter", "ptrt", "q", "redirect_location", "s", "search", "service", "show-service-calls", "start", "ticker", "anchor"]
  defp query_params_allowlist(_production_env), do: "*"

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "WorldServiceRedirect", :_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
