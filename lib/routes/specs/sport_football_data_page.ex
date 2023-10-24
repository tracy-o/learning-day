defmodule Routes.Specs.SportFootballDataPage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/football/teams/everton/top-scorers/assists", "/sport/football/teams/everton/top-scorers/assists.app", "/sport/football/teams/everton/top-scorers", "/sport/football/teams/everton/top-scorers.app", "/sport/football/european-championship/top-scorers/assists", "/sport/football/european-championship/top-scorers/assists.app", "/sport/football/european-championship/top-scorers", "/sport/football/european-championship/top-scorers.app", "/sport/football/teams/arsenal/table", "/sport/football/teams/arsenal/table.app", "/sport/football/championship/table", "/sport/football/championship/table.app", "/sport/football/tables", "/sport/football/tables.app", "/sport/football/premier-league/table.app", "/sport/football/league-two/table.app"]
      }
    }
  end
end
