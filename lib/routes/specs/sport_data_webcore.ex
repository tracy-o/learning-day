defmodule Routes.Specs.SportDataWebcore do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/sport/BBC+Sport+Technical+Design",
        platform: "Webcore",
        examples: [
          "/sport/alpha/netball/world-cup/scores-fixtures/2023-02-11",
          "/sport/app-webview/netball/world-cup/scores-fixtures/2023-02-11",
          "/sport/netball/world-cup/scores-fixtures/2023-02-11",
          "/sport/alpha/netball/world-cup/scores-fixtures",
          "/sport/app-webview/netball/world-cup/scores-fixtures",
          "/sport/netball/world-cup/scores-fixtures",
          "/sport/alpha/netball/scores-fixtures/2023-02-11",
          "/sport/app-webview/netball/scores-fixtures/2023-02-11",
          "/sport/netball/scores-fixtures/2023-02-11",
          "/sport/alpha/netball/scores-fixtures",
          "/sport/app-webview/netball/scores-fixtures",
          "/sport/netball/scores-fixtures",
          "/sport/alpha/basketball/nba/scores-fixtures/2021-04-26",
          "/sport/basketball/nba/scores-fixtures/2021-04-26",
          "/sport/alpha/basketball/nba/scores-fixtures",
          "/sport/basketball/nba/scores-fixtures",
          "/sport/alpha/basketball/scores-fixtures/2021-04-26",
          "/sport/basketball/scores-fixtures/2021-04-26",
          "/sport/alpha/basketball/scores-fixtures",
          "/sport/basketball/scores-fixtures"
        ]
      }
    }
  end
end
