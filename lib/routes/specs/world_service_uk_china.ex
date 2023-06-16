defmodule Routes.Specs.WorldServiceUkChina do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: pipeline(production_env),
        headers_allowlist: ["cookie-ckps_chinese"],
        examples: ["/ukchina/simp", "/ukchina/trad", "/ukchina/trad.json", "/ukchina/trad.amp"]
      }
    }
  end

  defp pipeline("live"), do: ["WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
