defmodule Routes.Specs.ContainerEnvelopeEditorialText do
  def specs do
    %{
      owner: "DENewsElections@bbc.co.uk",
      platform: Webcore,
      runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2021",
      query_params_allowlist: ["static"]
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "UserAgentValidator", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end
end