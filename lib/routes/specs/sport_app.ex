defmodule Routes.Specs.SportApp do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: MozartSport,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector"]
    }
  end
end
