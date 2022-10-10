defmodule Routes.Specs.WorldServiceAfaanoromoo do
  def specs(production_env) do
    %{
      platform: MozartSimorgh,
      pipeline: pipeline(production_env)
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
