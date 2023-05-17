defmodule Routes.Specs.WorldServiceAfaanoromoo do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: pipeline(production_env)
      }
    }
  end

  defp pipeline("live"), do: ["WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
