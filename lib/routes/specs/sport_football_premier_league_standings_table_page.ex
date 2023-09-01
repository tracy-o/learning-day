defmodule Routes.Specs.SportFootballPremierLeagueStandingsTablePage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/SLS/Sport+Football+Standings+Webcore+Container+Run+Book",
        platform: "Webcore",
        query_params_allowlist: ["q"],
        examples: ["/sport/football/premier-league/table"]
      }
    }
  end
end
