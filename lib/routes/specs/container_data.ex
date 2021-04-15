defmodule Routes.Specs.ContainerData do
  def specs(production_env) do
    %{
      platform: Webcore,
      query_params_allowlist: "*",
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "UserAgentValidator", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
