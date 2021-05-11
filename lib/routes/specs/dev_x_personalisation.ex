defmodule Routes.Specs.DevXPersonalisation do
  def specs(production_env) do
    %{
      owner: "devx@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["personalisationMode"],
      pipeline: pipeline(production_env),
      cookie_allowlist: ["ckns_atkn", "ckns_id"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "UserSession", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
