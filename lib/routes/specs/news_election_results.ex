defmodule Routes.Specs.NewsElectionResults do
  def specification do
    %{
      specs: %{
        owner: "DENewsElections@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Operational+support",
        platform: "Webcore",
        examples: ["/news/election/2022/northern-ireland/constituencies/N06000001", "/news/election/2022/wales/councils/W06000001", "/news/election/2022/northern-ireland/constituencies", "/news/election/2022/england/councils", "/news/election/2022/scotland/councils", "/news/election/2022/wales/councils", "/news/election/2022/england/results", "/news/election/2022/scotland/results", "/news/election/2022/wales/results", "/news/election/2022/northern-ireland/results", "/news/election/2022/us/states/al", "/news/election/2022/us/results", "/news/election/2023/england/councils/E08000019", "/news/election/2023/england/councils", "/news/election/2023/england/results"]
      }
    }
  end
end
