defmodule Routes.Specs.NewsNiElectionResults do
  def specification do
    %{
      specs: %{
        owner: "DENewsElections@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Operational+support",
        platform: "Webcore",
        request_pipeline: ["NiElectionFailoverMode"],
        examples: ["/news/election/2023/northern-ireland/councils/N09000001", "/news/election/2023/northern-ireland/results"]
      }
    }
  end
end
