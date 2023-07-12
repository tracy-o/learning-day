defmodule Routes.Specs.DotComReel do
  def specification do
    %{
      preflight_pipeline: ["BBCXReelPlatformSelector"],
      specs: [
        %{
          platform: "DotComReel",
          examples: ["/reel", "/reel/video/p0cjtl2v", "/reel/topic/travel"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
