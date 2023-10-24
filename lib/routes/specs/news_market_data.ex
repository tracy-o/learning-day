defmodule Routes.Specs.NewsMarketData do
  def specification do
    %{
      specs: %{
        email: "NewsAndSportWebTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/x/Og9rF",
        platform: "Webcore",
        query_params_allowlist: ["q"]
      }
    }
  end
end
