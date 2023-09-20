defmodule Routes.Specs.NewsIndex do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          owner: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          examples: ["/news/world_radio_and_tv", "/news/wales", "/news/technology", "/news/scotland", "/news/science_and_environment", "/news/politics", "/news/paradisepapers", "/news/northern_ireland", "/news/newsbeat", "/news/health", "/news/front-page-service-worker.js", "/news/front_page", "/news/explainers", "/news/entertainment_and_arts", "/news/england", "/news/education", "/news/disability", "/news/coronavirus", "/news/business", "/news/access-to-news"]
        },
        %{
          platform: "BBCX",
          request_pipeline: ["DomesticToBBCXRedirect"],
          examples: [
            %{expected_status: 302, path: "/news/business"},
            %{expected_status: 302, path: "/news/technology"},
            %{expected_status: 302, path: "/news/entertainment_and_arts"},
          ]
        }
      ]
    }
  end
end
