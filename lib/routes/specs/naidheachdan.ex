defmodule Routes.Specs.Naidheachdan do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: [%{expected_status: 301, path: "/naidheachdan/dachaigh"}]
      }
    }
  end
end
