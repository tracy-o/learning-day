defmodule Routes.Platforms.Pal do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :pal_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: pipeline(production_env),
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
