defmodule Routes.Specs.FullStackTestA do
  def specs(production_env) do
    %{
      owner: "fabl@onebbc.onmicrosoft.com",
      platform: Webcore,
      pipeline: pipeline(production_env),
      cookie_allowlist: ["ckns_atkn", "ckns_id"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
