defmodule Routes.Specs.NewsIndex do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: ["/news/world_radio_and_tv", "/news/wales", "/news/scotland", "/news/science_and_environment", "/news/politics", "/news/paradisepapers", "/news/northern_ireland", "/news/newsbeat", "/news/health", "/news/front-page-service-worker.js", "/news/front_page", "/news/explainers", "/news/england", "/news/disability", "/news/access-to-news"]
      }
    }
  end
end
