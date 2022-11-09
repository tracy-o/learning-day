defmodule Routes.Specs.WorldServiceSerbian do
  def specs(production_env) do
    %{
      platform: MozartSimorgh,
      request_pipeline: pipeline(production_env),
      headers_allowlist: ["cookie-ckps_serbian"]
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
