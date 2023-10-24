defmodule Routes.Specs.Archivist do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        query_params_allowlist: ["batch"],
        examples: []
      }
    }
  end
end
