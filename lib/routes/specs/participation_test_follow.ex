defmodule Routes.Specs.ParticipationTestFollow do
  def specs do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["personalisationMode"],
      pipeline: ["UserSession"],
      cookie_allowlist: ["ckns_atkn", "ckns_id"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end
end
