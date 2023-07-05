defmodule Routes.Specs.DotComTravel do
  def specification do
    %{
      preflight_pipeline: ["BBCXTravelPlatformSelector"],
      specs: [
        %{
          platform: "DotComTravel",
          examples: ["/travel"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
