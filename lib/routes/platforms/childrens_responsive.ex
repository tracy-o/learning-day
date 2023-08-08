defmodule Routes.Platforms.ChildrensResponsive do
  @moduledoc """
  This Platform is temporary. 
  It exists to allow CBBC & CBeebies migration from the "Childrens Responsive"
  platform to WebCore.
  Once migration is complete this plaform can be removed.
  """

  def specification(production_env) do
    %{
      origin: Application.get_env(:belfrage, :childrens_responsive_endpoint),
      owner: "childrensfutureweb@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/CE/CBBC+Responsive+Runbook",
      request_pipeline: pipeline(production_env),
      response_pipeline: ["CacheDirective", "ResponseHeaderGuardian", "PreCacheCompression"],
      circuit_breaker_error_threshold: 200
    }
  end

  defp pipeline("live"), do: [:_routespec_pipeline_placeholder, "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end