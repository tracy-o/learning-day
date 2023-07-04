defmodule Routes.Specs.DotComReel do
  def specification do
    %{
      preflight_pipeline: ["BBCXReelPlatformSelector"],
      specs: [
        %{
          request_pipeline: [],
          platform: "DotComReel",
          examples: ["/reel"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
