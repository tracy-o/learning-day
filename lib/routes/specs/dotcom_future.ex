defmodule Routes.Specs.DotComFuture do
  def specification do
    %{
      preflight_pipeline: ["BBCXFuturePlatformSelector"],
      specs: [
        %{
          request_pipeline: [],
          platform: "DotComFuture",
          examples: ["/future"]
        },
        %{
          platform: "BBCX",
          examples: []
        }
      ]
    }
  end
end
