defmodule Routes.Specs.DevXPersonalisation do
  def specs(production_env) do
    %{
      owner: "devx@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["personalisationMode"],
      pipeline: pipeline(production_env),
      personalisation: "test_only"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
