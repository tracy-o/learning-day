defmodule Routes.Specs.SportFootballIndexPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/football/world-cup", "/sport/football/world-cup.app", "/sport/football/womens", "/sport/football/womens.app", "/sport/football/premier-league", "/sport/football/premier-league.app", "/sport/football/irish.app", "/sport/football/fa-cup", "/sport/football/fa-cup.app", "/sport/football/european", "/sport/football/european.app", "/sport/football/european-championship", "/sport/football/european-championship.app", "/sport/football/championship", "/sport/football/championship.app", "/sport/football", "/sport/football.app"]
      }
    }
  end
end
