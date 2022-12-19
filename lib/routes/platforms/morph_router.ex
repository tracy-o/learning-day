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
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", :_routespec_pipeline_placeholder, "ResponseHeaderGuardian", "PreCacheCompression"],
      circuit_breaker_error_threshold: 200,
    }
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
