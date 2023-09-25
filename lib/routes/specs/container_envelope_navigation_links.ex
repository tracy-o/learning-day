defmodule Routes.Specs.ContainerEnvelopeNavigationLinks do
  def specification do
    %{
      specs: %{
        owner: "DEWeather@bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["UserAgentValidator"],
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=140399154",
        query_params_allowlist: ["static"],
        examples: [
          %{
            path: "/container/envelope/navigation-links/brandPalette/weatherLight/corePalette/light/country/gb/fontPalette/sansSimple/hasFetcher/true/language/en/service/weather?static=true",
            request_headers: %{"user-agent" => "MozartFetcher"}
          }
        ]
      }
    }
  end
end
