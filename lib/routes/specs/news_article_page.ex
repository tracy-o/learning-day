defmodule Routes.Specs.NewsArticlePage do
  def specification do
    %{
      preflight_pipeline: ["AssetTypePlatformSelector", "BBCXCPSPlatformSelector"],
      specs: [
        %{
          owner: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          circuit_breaker_error_threshold: 1_000,
          examples: []
        },
        %{
          owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
          platform: "Webcore",
          circuit_breaker_error_threshold: 1_000,
          request_pipeline: [
            "NewsAvRedirect",
            "ObitMode",
            "ElectionBannerCouncilStory",
            "ElectionBannerNiStory"
          ],
          examples: [
            "/news/uk-politics-49336144",
            "/news/world-asia-china-51787936",
            "/news/technology-51960865",
            "/news/uk-england-derbyshire-18291916",
            "/news/entertainment+arts-10636043"
          ]
        },
        %{
          platform: "BBCX",
          examples: [
            "/news/uk-politics-49336144",
            "/news/world-asia-china-51787936",
            "/news/technology-51960865",
            "/news/uk-england-derbyshire-18291916",
            "/news/entertainment+arts-10636043"
          ]
        }
      ]
    }
  end
end
