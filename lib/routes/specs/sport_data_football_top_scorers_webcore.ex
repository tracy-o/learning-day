defmodule Routes.Specs.SportDataFootballTopScorersWebcore do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "TODO SWDSOFT-438: add link to Football Top Scorers Runbook",
        platform: "Webcore",
        query_params_allowlist: ["q"],
        examples: [
          "/sport/alpha/football/premier-league/top-scorers",
          "/sport/alpha/football/premier-league/top-scorers.app",
          "/sport/alpha/football/teams/england/top-scorers",
          "/sport/alpha/football/teams/england/top-scorers.app"
        ]
      }
    }
  end
end
