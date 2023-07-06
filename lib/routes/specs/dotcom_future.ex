defmodule Routes.Specs.DotComFuture do
  def specification do
    %{
      preflight_pipeline: ["BBCXFuturePlatformSelector"],
      specs: [
        %{
          platform: "DotComFuture",
          examples: ["/future", "/future/article/20230630-will-texas-become-too-hot-for-humans"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
