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
            "/travel/worlds-table",
            "/travel/tags/history",
            "/travel/columns/culture-identity",
            "/travel/columns/adventure-experience",
            "/travel/columns/the-specialist"
          ]
        },
        %{
          platform: "BBCX",
          request_pipeline: ["DomesticToBBCXRedirect"],
          examples: [
            "/travel",
            "/travel/destinations",
            "/travel/destinations/asia",
            "/travel/tags/covid-19",
            "/travel/worlds-table",
            %{expected_status: 302, path: "/travel/tags/history"},
            %{expected_status: 302, path: "/travel/columns/culture-identity"},
            %{expected_status: 302, path: "/travel/columns/adventure-experience"},
            %{expected_status: 302, path: "/travel/columns/the-specialist"},
          ]
        }
      ]
    }
  end
end
