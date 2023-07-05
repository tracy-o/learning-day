defmodule Routes.Specs.DotComReel do
  def specification do
    %{
      preflight_pipeline: ["BBCXReelPlatformSelector"],
      specs: [
        %{
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
