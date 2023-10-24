defmodule Routes.Platforms.Ares do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :ares_endpoint),
      email: "DENewsSimorghDev@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Simorgh+Run+Book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", :_routespec_pipeline_placeholder, "ResponseHeaderGuardian", "PreCacheCompression"],
      circuit_breaker_error_threshold: 200
    }
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
