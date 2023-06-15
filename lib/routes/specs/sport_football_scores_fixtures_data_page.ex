defmodule Routes.Specs.SportFootballScoresFixturesDataPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/football/teams/hull-city/scores-fixtures", "/sport/football/teams/hull-city/scores-fixtures.app", "/sport/football/champions-league/scores-fixtures", "/sport/football/champions-league/scores-fixtures.app"]
      }
    }
  end
end
