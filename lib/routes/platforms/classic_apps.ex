
# Does it makes sense to have 1 classic apps platform?
# philippa -> 335rps, walter -> 1200rps, trevor -> as much as 2200 rps
# we have vastly varying rps on each endpoint, so it would make sense to have a different error_threshold for each?
# We could put this in the app host mapping, but then it would be doing a little more than host mapping



defmodule Routes.Platforms.ClassicApps do
  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :trevor_endpoint),
      owner: "#data-systems",
      runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
      pipeline: pipeline(production_env),
      circuit_breaker_error_threshold: 200 # REMOVE ME: decide reasonable error threshold for trevor walter & philippa
    }
  end

  defp pipeline("live"), do: ["HTTPredirect", "TrailingSlashRedirector", :_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
