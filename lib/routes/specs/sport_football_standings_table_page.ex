defmodule Routes.Specs.SportFootballStandingsTablePage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/SLS/Sport+Football+Standings+Webcore+Container+Run+Book",
        platform: "Webcore",
        examples: ["/sport/football/league-two/table"]
      }
    }
  end
end
