defmodule Routes.Specs.WsImages do
  def specs(production_env) do
    %{
      platform: MozartSimorgh,
      request_pipeline: pipeline(production_env),
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
