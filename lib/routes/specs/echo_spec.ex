defmodule Routes.Specs.EchoSpec do
    def specs do
      %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        pipeline: ["Echo"],
        platform: Webcore,
        query_params_allowlist: ["size", "sleep"],
        headers_allowlist: ["size", "sleep"]
      }
    end
  end
