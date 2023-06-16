defmodule Routes.Specs.SportDataWebcore do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/sport/BBC+Sport+Technical+Design",
        platform: "Webcore",
        examples: ["/sport/app-webview/netball/world-cup/scores-fixtures/2023-02-11", "/sport/netball/world-cup/scores-fixtures/2023-02-11", "/sport/app-webview/netball/world-cup/scores-fixtures", "/sport/netball/world-cup/scores-fixtures", "/sport/app-webview/netball/scores-fixtures/2023-02-11", "/sport/netball/scores-fixtures/2023-02-11", "/sport/app-webview/netball/scores-fixtures", "/sport/netball/scores-fixtures", "/sport/basketball/nba/scores-fixtures/2021-04-26", "/sport/basketball/nba/scores-fixtures", "/sport/basketball/scores-fixtures/2021-04-26", "/sport/basketball/scores-fixtures", "/sport/alpha/football/premier-league/scores-fixtures/2023-02-21", "/sport/alpha/football/premier-league/scores-fixtures", "/sport/alpha/football/scores-fixtures/2023-02-21", "/sport/alpha/football/scores-fixtures"]
      }
    }
  end
end
