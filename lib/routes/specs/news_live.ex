defmodule Routes.Specs.NewsLive do
  def specs(production_env) do
    %{
      platform: MozartNews,
      circuit_breaker_error_threshold: 500,
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
