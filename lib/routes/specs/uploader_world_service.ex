defmodule Routes.Specs.UploaderWorldService do
  def specs(production_env) do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=183485635",
      platform: MorphRouter,
      request_pipeline: pipeline(production_env),
    }
  end

  defp pipeline("live"), do: ["WorldServiceRedirect", "CircuitBreaker"]
  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
