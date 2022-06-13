defmodule Routes.Platforms.Karanga do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :karanga_endpoint),
      owner: "",
      runbook: "https://confluence.dev.bbc.co.uk/display/wsresponsive/News+RSS+Feeds+Run+Book",
      pipeline: pipeline(production_env),
      circuit_breaker_error_threshold: 200
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", :_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end