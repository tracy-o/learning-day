defmodule Routes.Specs.PresTestPersonalised do
  def specs do
    %{
      owner: "D&EWebCorePresentationTeam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["q", "page", "scope", "filter"],
      pipeline: ["RestrictedPersonalisation", "UserSession"],
      cookie_allowlist: ["ckns_atkn"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end
end
