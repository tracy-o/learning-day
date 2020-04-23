defmodule Routes.Platforms.Webcore do
  def specs(production_environment) do
    %{
      origin: Application.get_env(:belfrage, :pwa_lambda_function),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias", "CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100,
      query_params_allowlist: query_params_allowlist(production_environment)
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_environment), do: ["mode"]
end
