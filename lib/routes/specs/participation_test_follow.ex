defmodule Routes.Specs.ParticipationTestFollow do
  def specs(production_env) do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["page"],
      pipeline: pipeline(production_env),
      personalisation: "test_only"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests", "Personalisation"]
end
