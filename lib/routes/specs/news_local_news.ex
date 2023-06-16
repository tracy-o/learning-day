defmodule Routes.Specs.NewsLocalNews do
  def specification do
    %{
      specs: %{
        owner: "DENewsCardiff@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/news/Location+topic+page+run+book",
        platform: "MozartNews",
        examples: ["/news/localnews/locations/sitemap.xml", "/news/localnews/locations", "/news/localnews/faqs", "/news/localnews"]
      }
    }
  end
end
