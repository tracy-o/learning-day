defmodule Routes.Specs.NaidheachdanArticlePage do
  def specification do
    %{
      specs: %{
        email: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
        platform: "Webcore",
        default_language: "gd",
        examples: ["/naidheachdan/52992845", "/naidheachdan/52990788", "/naidheachdan/52991029"]
      }
    }
  end
end
