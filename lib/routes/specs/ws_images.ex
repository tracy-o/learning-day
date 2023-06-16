defmodule Routes.Specs.WsImages do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: pipeline(production_env),
        query_params_allowlist: ["alternativeJsLoading", "batch"],
        examples: [%{expected_status: 301, path: "/worldservice/assets/images/2012/07/12/120712163431_img_0328.jpg"}]
      }
    }
  end

  defp pipeline("live"), do: ["CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
