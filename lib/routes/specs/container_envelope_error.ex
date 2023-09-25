defmodule Routes.Specs.ContainerEnvelopeError do
  def specification do
    %{
      specs: %{
        owner: "d&ewebcorepresentationteam@bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["UserAgentValidator"],
        runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/Presentation+Layer+Run+Book",
        query_params_allowlist: ["static"],
        examples: [
          %{
            path: "/container/envelope/error/brandPalette/weatherLight/fontPalette/sansSimple/linkText/BBC%20Weather/linkUrl/%2Fweather/status/500?static=true",
            headers: %{"user-agent" => "MozartFetcher"}
          }
        ]
      }
    }
  end
end
