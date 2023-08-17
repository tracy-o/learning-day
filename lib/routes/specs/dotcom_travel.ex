defmodule Routes.Specs.DotComTravel do
  def specification do
    %{
      preflight_pipeline: ["BBCXTravelPlatformSelector"],
      specs: [
        %{
          platform: "DotComTravel",
          examples: [
            "/travel",
            "/travel/destinations",
            "/travel/destinations/asia",
            "/travel/destinations/japan",
            "/travel/tags/covid-19",
            "/travel/worlds-table"
          ]
        },
        %{
          platform: "BBCX",
          examples: [
            "/travel",
            "/travel/destinations",
            "/travel/destinations/asia",
            "/travel/destinations/japan",
            "/travel/tags/covid-19",
            "/travel/worlds-table"
          ]
        }
      ]
    }
  end
end
