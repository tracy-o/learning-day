defmodule Routes.Specs.BBCXIndex do
  def specification do
    %{
      specs: %{
        request_pipeline: ["BBCXRedirect"],
        platform: "BBCX",
        examples: [
          %{expected_status: 302, path: "/business"},
          %{expected_status: 302, path: "/business/c-suite"},
          %{expected_status: 302, path: "/business/future-of-business"},
          %{expected_status: 302, path: "/business/global-business"},
          %{expected_status: 302, path: "/business/technology-of-business"},
          %{expected_status: 302, path: "/business/us-canada-business"},
          %{expected_status: 302, path: "/culture/art"},
          %{expected_status: 302, path: "/culture/books"},
          %{expected_status: 302, path: "/culture/entertainment-news"},
          %{expected_status: 302, path: "/culture/film-tv"},
          %{expected_status: 302, path: "/future-planet"},
          %{expected_status: 302, path: "/future-planet/climate-news"},
          %{expected_status: 302, path: "/future-planet/solutions"},
          %{expected_status: 302, path: "/future-planet/environment"},
          %{expected_status: 302, path: "/innovation"},
          %{expected_status: 302, path: "/innovation/tech"},
          %{expected_status: 302, path: "/innovation/science"},
          %{expected_status: 302, path: "/innovation/artificial-intelligence"},
          %{expected_status: 302, path: "/innovation/future-now"},
          %{expected_status: 302, path: "/live"},
          %{expected_status: 302, path: "/news/long_reads"},
          %{expected_status: 302, path: "/news/us-canada"},
          %{expected_status: 302, path: "/news/war-in-ukraine"},
          %{expected_status: 302, path: "/travel/adventures"},
          %{expected_status: 302, path: "/travel/cultural-experiences"},
          %{expected_status: 302, path: "/travel/history-heritage"},
          %{expected_status: 302, path: "/travel/specialist"},
          %{expected_status: 302, path: "/video"}
        ]
      }
    }
  end
end