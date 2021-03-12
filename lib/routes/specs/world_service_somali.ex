defmodule Routes.Specs.WorldServiceSomali do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
