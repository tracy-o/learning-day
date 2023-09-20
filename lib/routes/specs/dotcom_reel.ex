defmodule Routes.Specs.DotComReel do
  def specification do
    %{
      preflight_pipeline: ["BBCXReelPlatformSelector"],
      specs: [
        %{
          platform: "DotComReel",
          examples: ["/reel/video/p0frkb7n/what-did-stonehenge-sound-like-", "/reel/topic/travel"]
        },
        %{
          platform: "BBCX",
          request_pipeline: ["DomesticToBBCXRedirect"],
          examples: [
            "/reel/video/p0frkb7n/what-did-stonehenge-sound-like-",
            "/reel/topic/travel",
            %{expected_status: 302, path: "/reel"}
          ]
        }
      ]
    }
  end
end
