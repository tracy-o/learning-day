defmodule Routes.Specs.NewsElection2021 do
  def specification do
    %{
      specs: %{
        email: "DENewsElections@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2021",
        platform: "Webcore",
        examples: ["/news/election/2021/scotland/constituencies/S16000084", "/news/election/2021/scotland/regions/S17000014", "/news/election/2021/wales/constituencies/W09000001", "/news/election/2021/wales/regions/W10000006", "/news/election/2021/england/councils/E06000023", "/news/election/2021/england/councils", "/news/election/2021/scotland/constituencies", "/news/election/2021/wales/constituencies", "/news/election/2021/england/results", "/news/election/2021/scotland/results", "/news/election/2021/wales/results"]
      }
    }
  end
end
