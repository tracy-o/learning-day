defmodule Routes.Specs.BBCXIndex do
  def specification do
    %{
      specs: %{
        request_pipeline: ["BBCXRedirect"],
        platform: "BBCX",
        examples: [
          %{expected_status: 302, path: "/business"},
          %{expected_status: 302, path: "/business/technology-of-business"},
          %{expected_status: 302, path: "/future-planet"},
          %{expected_status: 302, path: "/innovation"},
          %{expected_status: 302, path: "/live"},
          %{expected_status: 302, path: "/news/in-pictures"},
          %{expected_status: 302, path: "/news/long-reads"},
          %{expected_status: 302, path: "/news/us-canada"},
          %{expected_status: 302, path: "/news/war-in-ukraine"},
          %{expected_status: 302, path: "/news/world/latin-america"},
          %{expected_status: 302, path: "/news/world/middle-east"},
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