defmodule Routes.Specs.DevXPersonalisation do
  def specs(production_env) do
    %{
      owner: "devx@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["personalisationMode"],
      pipeline: pipeline(production_env),
      personalisation: "on"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
