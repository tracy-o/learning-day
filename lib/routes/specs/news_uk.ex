defmodule Routes.Specs.NewsUk do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: ["/news/politics/eu_referendum/results", "/news/northern_ireland/northern_ireland_politics", "/news/local_news_slice/%252Fnews%252Fengland%252Flondon", "/news/events/scotland-decides/results", "/news/england/regions", "/news/uk-england-47486169"]
      }
    }
  end
end
