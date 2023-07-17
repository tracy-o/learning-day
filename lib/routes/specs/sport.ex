defmodule Routes.Specs.Sport do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
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
        "/sport/extra/c1nx5lutpg/The-real-Lewis-Hamilton-story", 
        %{expected_status: 404, path: "/sport/american-football.app"}, 
        %{expected_status: 404, path: "/sport/basketball.app"}, 
        %{expected_status: 404, path: "/sport/boxing.app"}, 
        %{expected_status: 404, path: "/sport/disability-sport.app"}, 
        %{expected_status: 404, path: "/sport/football/european-championship.app"}, 
        %{expected_status: 404, path: "/sport/football/european.app"}, 
        %{expected_status: 404, path: "/sport/football/fa-cup.app"}, 
        %{expected_status: 404, path: "/sport/football/irish.app"}, 
        %{expected_status: 404, path: "/sport/football/premier-league.app"}, 
        %{expected_status: 404, path: "/sport/football/scottish.app"}, 
        %{expected_status: 404, path: "/sport/football/welsh.app"}, 
        %{expected_status: 404, path: "/sport/football/world-cup.app"}, 
        %{expected_status: 404, path: "/sport/golf.app"}, 
        %{expected_status: 404, path: "/sport/mixed-martial-arts.app"}, 
        %{expected_status: 404, path: "/sport/motorsport.app"}, 
        %{expected_status: 404, path: "/sport/netball.app"}, 
        %{expected_status: 404, path: "/sport/northern-ireland.app"}, 
        %{expected_status: 404, path: "/sport/northern-ireland/gaelic-games.app"}, 
        %{expected_status: 404, path: "/sport/northern-ireland/motorbikes.app"}, 
        %{expected_status: 404, path: "/sport/rugby-union/english.app"}, 
        %{expected_status: 404, path: "/sport/rugby-union/irish.app"}, 
        %{expected_status: 404, path: "/sport/rugby-union/scottish.app"}, 
        %{expected_status: 404, path: "/sport/rugby-union/welsh.app"}, 
        %{expected_status: 404, path: "/sport/scotland.app"}, 
        %{expected_status: 404, path: "/sport/snooker.app"}, 
        %{expected_status: 404, path: "/sport/sports-personality.app"}, 
        %{expected_status: 404, path: "/sport/wales.app"}, 
        %{expected_status: 404, path: "/sport/winter-sports.app"}]
      }
    }
  end
end
