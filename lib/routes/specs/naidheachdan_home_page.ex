defmodule Routes.Specs.NaidheachdanHomePage do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        request_pipeline: ["NaidheachdanObitRedirect"]
      }
    }
  end
end
