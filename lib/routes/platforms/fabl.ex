defmodule Routes.Platforms.Fabl do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :fabl_endpoint),
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
      pipeline: pipeline(production_env),
      resp_pipeline: [],
      query_params_allowlist: "*",
      circuit_breaker_error_threshold: 100,
      platform_signature_keys: []
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
