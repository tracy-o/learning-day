defmodule Routes.Specs.WorldServiceUzbek do
  def specs(production_env) do
    %{
      platform: MozartSimorgh,
      request_pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
