defmodule Routes.Platforms.MozartSimorgh do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :mozart_news_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      pipeline: pipeline(production_env),
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200,
      signature_keys: %{add: [:is_advertise], skip: [:country]}
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["renderer_env", "morph_env", "component_env"]

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
