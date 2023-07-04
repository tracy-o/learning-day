defmodule Routes.Specs.DotComTravel do
  def specification do
    %{
      preflight_pipeline: ["BBCXTravelPlatformSelector"],
      specs: [
        %{
          request_pipeline: [],
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
