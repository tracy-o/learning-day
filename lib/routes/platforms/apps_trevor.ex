defmodule Routes.Platforms.AppsTrevor do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :trevor_endpoint),
      slack_channel: "#data-systems",
      runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
      circuit_breaker_error_threshold: 15_000,
      fallback_write_sample: 0.0,
      query_params_allowlist: ["subjectId", "language", "createdBy"],
      etag: true,
      examples: %{
        request_headers: %{
          "host" => "news-app-classic.api.bbci.co.uk"
        }
      }
    }
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
