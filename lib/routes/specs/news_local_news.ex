defmodule Routes.Specs.NewsLocalNews do
  def specification do
    %{
      specs: %{
        email: "DENewsCardiff@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/news/Location+topic+page+run+book",
        platform: "MozartNews",
        examples: ["/news/localnews/locations/sitemap.xml", "/news/localnews"]
      }
    }
  end
end
