defmodule Routes.Specs.EchoSpec do
    def specs do
      %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        request_pipeline: ["Echo"],
        platform: Webcore,
        query_params_allowlist: ["latency", "size"],
        headers_allowlist: ["latency", "size"]
      }
    end
  end
