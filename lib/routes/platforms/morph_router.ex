defmodule Routes.Platforms.MorphRouter do
  @moduledoc """
  This Platform is temporary. It exists because of a requirement in
  https://jira.dev.bbc.co.uk/browse/RESFRAME-4439 to have a way of fetching
  requests from the morph router origin to aid the migration of bitesize from
  morph router to webcore.
  """


  def specs(production_env) do
    %{
      origin: Application.get_env(:belfrage, :morph_router_endpoint),
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/morph/Morph+Router+Run+Book",
      pipeline: pipeline(production_env),
      circuit_breaker_error_threshold: 200,
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "CircuitBreaker"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
