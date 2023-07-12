defmodule Routes.Specs.DotComTravel do
  def specification do
    %{
      preflight_pipeline: ["BBCXTravelPlatformSelector"],
      specs: [
        %{
          platform: "DotComTravel",
          examples: ["/travel", "/travel/tags/covid-19"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
