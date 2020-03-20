defmodule Routes.Platforms.Pal do
  def specs(_production_env) do
    %{
      origin: Application.get_env(:belfrage, :pal_endpoint),
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      pipeline: ["HTTPredirect", "DevelopmentRequests", "CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100
    }
  end
end
