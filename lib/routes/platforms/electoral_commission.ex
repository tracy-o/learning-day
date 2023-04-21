defmodule Routes.Platforms.ElectoralCommission do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :electoral_commission_endpoint),
      owner: "NewsSpecialsDevelopment2@bbc.co.uk@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2023",
      request_pipeline: request_pipeline(production_env),
      response_pipeline: ["CacheDirective", "ElectoralCommissionResponseHandler", "ResponseHeaderGuardian", "PreCacheCompression"],
      query_params_allowlist: [],
      circuit_breaker_error_threshold: 60
    }
  end

  defp request_pipeline("live"), do: ["ElectoralCommissionPath", :_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp request_pipeline(_production_env), do: request_pipeline("live") ++ ["DevelopmentRequests"]
end
