# This platform is used in conjunction with the AppSubdomainMapper transformer.
#
# The AppSubdomainMapper transformer overwrites the circuit breaker error
# threshold and the origin based upon the subdomain of the request.
# Also notice there is no HTTPredirect or TrailingSlashRedirector, this is
# because we always expect apps to give us a valid URL.

defmodule Routes.Platforms.ClassicApps do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :trevor_endpoint),
      owner: "#data-systems",
      runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
      circuit_breaker_error_threshold: 1000,
      fallback_write_sample: 0.0,
      examples: %{
        request_headers: %{"host" => "news-app-classic.api.bbci.co.uk"}
      }
    }
  end

  defp pipeline("live"), do: ["AppSubdomainMapper", :_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
