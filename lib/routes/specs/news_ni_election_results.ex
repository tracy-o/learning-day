defmodule Routes.Specs.NewsNiElectionResults do
  def specification do
    %{
      specs: %{
        owner: "DENewsElections@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Operational+support",
        platform: "Webcore",
        request_pipeline: ["NiElectionFailoverMode"]
      }
    }
  end
end
