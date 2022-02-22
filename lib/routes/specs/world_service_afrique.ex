defmodule Routes.Specs.WorldServiceAfrique do
  def specs(production_env) do
    %{
      platform: MozartSimorgh,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
