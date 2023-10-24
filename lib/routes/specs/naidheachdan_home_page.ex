defmodule Routes.Specs.NaidheachdanHomePage do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        request_pipeline: ["NaidheachdanObitRedirect"],
        examples: ["/naidheachdan"]
      }
    }
  end
end
