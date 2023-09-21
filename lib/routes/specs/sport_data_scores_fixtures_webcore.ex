defmodule Routes.Specs.SportDataScoresFixturesWebcore do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "TODO SWDSOFT-440: add link to Sport Data Scores Fixtures Runbook",
        platform: "Webcore",
        query_params_allowlist: ["filter", "q"],
        examples: [
          "/sport/alpha/cricket/teams/england/scores-fixtures/2023-09",
          "/sport/alpha/cricket/teams/england/scores-fixtures/2023-09.app",
          "/sport/alpha/cricket/teams/england/scores-fixtures",
          "/sport/alpha/cricket/teams/england/scores-fixtures.app",
          "/sport/alpha/cricket/indian-premier-league/scores-fixtures/2023-09",
          "/sport/alpha/cricket/indian-premier-league/scores-fixtures/2023-09.app",
          "/sport/alpha/cricket/indian-premier-league/scores-fixtures",
          "/sport/alpha/cricket/indian-premier-league/scores-fixtures.app",
          "/sport/alpha/cricket/scores-fixtures/2023-09-14",
          "/sport/alpha/cricket/scores-fixtures/2023-09-14.app",
          "/sport/alpha/cricket/scores-fixtures",
          "/sport/alpha/cricket/scores-fixtures.app",
          "/sport/alpha/football/premier-league/scores-fixtures/2023-02",
          "/sport/alpha/football/premier-league/scores-fixtures/2023-02.app",
          "/sport/alpha/football/premier-league/scores-fixtures",
          "/sport/alpha/football/premier-league/scores-fixtures.app",
          "/sport/alpha/football/scores-fixtures/2023-02-21",
          "/sport/alpha/football/scores-fixtures/2023-02-21.app",
          "/sport/alpha/football/scores-fixtures",
          "/sport/alpha/football/scores-fixtures.app"
        ]
      }
    }
  end
end
