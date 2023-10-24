defmodule Routes.Specs.Sport do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/sitemap.xml",
        "/sport/top-4",
        "/sport/top-4.app",
        "/sport/alpha/top-4",
        "/sport/alpha/top-4.app",
        "/sport/internal/ranked-list/lions-2021-XV?morph_env=live&renderer_env=live",
        "/sport/internal/player-rater/EFBO2128305?morph_env=live&renderer_env=live",
        "/sport/internal/football-team-selector/england-xi?morph_env=live&renderer_env=live",
        "/sport/extra/c1nx5lutpg/The-real-Lewis-Hamilton-story"]
      }
    }
  end
end
