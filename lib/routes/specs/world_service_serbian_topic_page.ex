defmodule Routes.Specs.WorldServiceSerbianTopicPage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["page"],
      headers_allowlist: ["cookie-ckps_serbian"]
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "WorldServiceTopicsRedirect", "WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
