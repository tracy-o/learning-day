defmodule Routes.Specs.SportStoryPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/swimming/56674917?morph_env=live&renderer_env=live", "/sport/swimming/56674917.app?morph_env=live&renderer_env=live", "/sport/rugby-union/teams", "/sport/rugby-union/teams.app", "/sport/rugby-league/teams", "/sport/rugby-league/teams.app", "/sport/my-sport", "/sport/my-sport.app", "/sport/football/transfers", "/sport/football/transfers.app", "/sport/football/teams", "/sport/football/teams.app", "/sport/football/scottish/gossip", "/sport/football/scottish/gossip.app", "/sport/football/leagues-cups", "/sport/football/leagues-cups.app", "/sport/football/gossip", "/sport/football/gossip.app", "/sport/cricket/teams", "/sport/cricket/teams.app", "/sport/all-sports", "/sport/all-sports.app"]
      }
    }
  end
end
