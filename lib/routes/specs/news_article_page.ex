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
            "/news/entertainment+arts-10636043",
            "/news/world-middle+east-10642960",
            "/news/election-2019-50319040",
            "/news/election-2015-northern-ireland-32488247",
            "/news/election-2016-wales-36207410",
            "/news/64265510"
          ]
        },
        %{
          platform: "BBCX",
          request_pipeline: ["DomesticToBBCXRedirect"],
          examples: [
            "/news/uk-politics-49336144",
            "/news/world-asia-china-51787936",
            "/news/technology-51960865",
            "/news/uk-england-derbyshire-18291916",
            "/news/entertainment+arts-10636043",
            %{expected_status: 302, path: "/news/world-60525350"}
          ]
        }
      ]
    }
  end
end
