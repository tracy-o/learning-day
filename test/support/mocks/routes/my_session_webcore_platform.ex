defmodule Routes.Specs.MySessionWebcorePlatform do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: Webcore,
      pipeline: ["RestrictedPersonalisation", "UserSession"],
      cookie_allowlist: ["ckns_atkn"],
      headers_allowlist: ["x-id-oidc-signedin"]
    }
  end
end
