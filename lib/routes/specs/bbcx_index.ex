defmodule Routes.Specs.BBCXIndex do
  def specification do
    %{
      specs: %{
        request_pipeline: ["BBCXRedirect"],
        platform: "BBCX",
        examples: [
          "/business",
          "/business/c-suite",
          "/business/future-of-business",
          "/business/global-business",
          "/business/technology-of-business",
          "/business/us-canada-business",
          "/culture/art",
          "/culture/books",
          "/culture/entertainment-news",
          "/culture/film-tv",
          "/future-planet",
          "/future-planet/climate-news",
          "/future-planet/solutions",
          "/future-planet/environment",
          "/innovation",
          "/innovation/technology",
          "/innovation/science",
          "/innovation/artificial-intelligence",
          "/innovation/future-now",
          "/live",
          "/news/long_reads",
          "/news/us-canada",
          "/news/war-in-ukraine",
          "/travel/adventures",
          "/travel/cultural-experiences",
          "/travel/history-heritage",
          "/travel/specialist",
          "/video"
        ]
      }
    }
  end
end
