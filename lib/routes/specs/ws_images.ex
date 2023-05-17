defmodule Routes.Specs.WsImages do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: pipeline(production_env),
        query_params_allowlist: ["alternativeJsLoading", "batch"]
      }
    }
  end

  defp pipeline("live"), do: ["CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
