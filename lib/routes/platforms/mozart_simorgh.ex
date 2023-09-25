defmodule Routes.Platforms.MozartSimorgh do
  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :mozart_news_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/MOZART/Mozart+Run+Book",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: query_params_allowlist(production_env),
      circuit_breaker_error_threshold: 200,
      signature_keys: %{add: [:is_advertise], skip: [:country]},
      examples: %{
        headers: %{"x-forwarded-host" => "www.bbc.com"}
      }
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["component_env", "morph_env", "renderer_env"]

  defp pipeline("live"), do: ["CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
