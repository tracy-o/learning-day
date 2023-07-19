defmodule Routes.Specs.DotComTravel do
  def specification do
    %{
      preflight_pipeline: ["BBCXTravelPlatformSelector"],
      specs: [
        %{
          platform: "DotComTravel",
          examples: ["/travel", "/travel/tags/covid-19", "/travel/destinations/japan"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
