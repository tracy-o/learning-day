defmodule Routes.Specs.DotComCulture do
  def specification do
    %{
      preflight_pipeline: ["BBCXCulturePlatformSelector"],
      specs: [
        %{
          platform: "DotComCulture",
          examples: [
            "/culture",
            "/culture/tags/jazz-music",
            "/culture/columns/film",
            "/culture/columns/art",
            "/culture/tags/books"
          ]
        },
        %{
          request_pipeline: ["DomesticToBBCXRedirect"],
          platform: "BBCX",
          examples: [
            "/culture",
            "/culture/style",
            "/culture/music",
            "/culture/tags/jazz-music",
            %{expected_status: 302, path: "/culture/columns/film"},
            %{expected_status: 302, path: "/culture/columns/art"},
            %{expected_status: 302, path: "/culture/tags/books"},
          ]
        },
      ]
    }
  end
end
