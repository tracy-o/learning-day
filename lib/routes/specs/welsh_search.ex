defmodule Routes.Specs.WelshSearch do
  def specs(production_env) do
    %{
      owner: "D+ESearchAndNavigationDev@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
      pipeline: pipeline(production_env),
      platform: Webcore,
      query_params_allowlist: ["q", "page", "scope", "filter"],
      default_language: "cy"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "ComToUKRedirect", "Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end
