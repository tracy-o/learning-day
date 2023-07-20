defmodule Routes.Platforms.BBCX do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :bbcx_endpoint),
      owner: "GnlDevOps@bbc.com",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCX/BBCX+Product+and+Technology+Run+book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      headers_allowlist: headers_allowlist(production_env),
      circuit_breaker_error_threshold: 200,
      examples: %{
        headers: %{
          "x-country" => "us",
          "x-bbc-edge-host" => "www.bbc.com",
          "cookie-ckns_bbccom_beta" => "1"
        }
      }
    }
  end

  defp headers_allowlist("live"), do: []
  defp headers_allowlist(_production_env), do: ["cookie-ckns_bbccom_beta"]

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
