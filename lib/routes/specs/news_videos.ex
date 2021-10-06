defmodule Routes.Specs.NewsVideos do
  def specs(production_env) do
    %{
      owner: "sfv-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: Webcore,
      query_params_allowlist: query_params_allowlist(production_env),
      pipeline: pipeline(production_env)
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["features"]

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "Language", "DatalabMachineRecommendations", "PlatformKillSwitch", "Chameleon", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
