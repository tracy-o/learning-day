defmodule Routes.Platforms.Webcore do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :pwa_lambda_function),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: pipeline(production_env),
      resp_pipeline: [],
      circuit_breaker_error_threshold: 200,
      query_params_allowlist: query_params_allowlist(production_env)
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["mode", "chameleon"]

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
