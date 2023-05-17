defmodule Routes.Specs.WorldServiceZhongwen do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: pipeline(production_env),
        headers_allowlist: ["cookie-ckps_chinese"]
      }
    }
  end

  defp pipeline("live"), do: ["WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
