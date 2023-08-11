defmodule Routes.Specs.Schoolreport do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: [%{expected_status: 301, path: "/schoolreport/home"}]
      }
    }
  end
end
