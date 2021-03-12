defmodule Routes.Specs.NaidheachdanHomePage do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: MozartNews,
      pipeline: ["HTTPredirect", "NaidheachdanObitRedirect", "TrailingSlashRedirector"]
    }
  end
end
