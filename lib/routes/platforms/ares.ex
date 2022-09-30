defmodule Routes.Platforms.Ares do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :ares_endpoint),
      owner: "DENewsSimorghDev@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Simorgh+Run+Book",
      pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "CustomRssErrorResponse"],
      circuit_breaker_error_threshold: 200
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
