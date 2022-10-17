defmodule Routes.Platforms.AppsTrevor do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :trevor_endpoint),
      owner: "#data-systems",
      runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
      request_pipeline: pipeline(production_env),
      circuit_breaker_error_threshold: 15_000,
      fallback_write_sample: 0.0
    }
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
