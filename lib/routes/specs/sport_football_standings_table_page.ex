defmodule Routes.Specs.SportFootballStandingsTablePage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/SLS/Sport+Football+Standings+Webcore+Container+Run+Book",
        platform: "Webcore",
        query_params_allowlist: ["q"],
        examples: ["/sport/football/league-two/table"]
      }
    }
  end
end
