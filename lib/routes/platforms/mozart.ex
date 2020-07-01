defmodule Routes.Platforms.Mozart do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      pipeline: pipeline(production_env),
      resp_pipeline: [],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 100,
      headers_allowlist: ["x-cookie-ckps_language", "x-cookie-ckps_chinese", "x-cookie-ckps_serbian"]
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: "*"

  defp pipeline("live"), do: ["TrailingSlashRedirector", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
