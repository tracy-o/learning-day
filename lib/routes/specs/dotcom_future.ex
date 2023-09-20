defmodule Routes.Specs.DotComFuture do
  def specification do
    %{
      preflight_pipeline: ["BBCXFuturePlatformSelector"],
      specs: [
        %{
          platform: "DotComFuture",
          examples: [
            "/future/article/20230630-will-texas-become-too-hot-for-humans",
            "/future/tags/oceans"
          ]
        },
        %{
          platform: "BBCX",
          request_pipeline: ["DomesticToBBCXRedirect"],
          examples: [
            "/future/article/20230630-will-texas-become-too-hot-for-humans",
            "/future/article/20230815-how-undersea-sounds-help-us-understand-ocean-life",
            "/future/tags/oceans",
            "/future/tags/environment",
            %{expected_status: 302, path: "/future"},
            %{expected_status: 302, path: "/future/future-planet"}
          ]
        }
      ]
    }
  end
end
