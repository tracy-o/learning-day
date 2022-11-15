defmodule Routes.Specs.WorldServiceBurmese do
  def specs(production_env) do
    %{
      platform: MozartSimorgh,
      request_pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live"), do: ["WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
