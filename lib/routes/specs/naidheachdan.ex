defmodule Routes.Specs.Naidheachdan do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: Mozart,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector"]
    }
  end
end
