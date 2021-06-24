defmodule Routes.Platforms.Programmes do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :programmes_endpoint),
      owner: "programmes@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
      pipeline: pipeline(production_env),
      resp_pipeline: [],
      query_params_allowlist: ["*"],
      circuit_breaker_error_threshold: 200
    }
  end

  defp pipeline("live"), do: ["TrailingSlashRedirector", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
