defmodule Routes.Specs.Weather do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: MozartWeather,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector"],
      headers_allowlist: ["cookie-ckps_language"]
    }
  end
end
