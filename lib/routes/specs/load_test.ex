defmodule Routes.Specs.LoadTest do
  def specs(production_env) do
    %{
      owner: "D&EFablTeam@bbc.co.uk", # This needs correcting to whatever our team email address is
      platform: Webcore,
      pipeline: pipeline(production_env),
      cookie_allowlist: ["ckns_atkn", "ckns_id"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end

  defp pipeline(_production_env) do
    ["HTTPredirect", "TrailingSlashRedirector", "UserSession", "LambdaOriginAlias", "CircuitBreaker", "Language"]
  end

end
