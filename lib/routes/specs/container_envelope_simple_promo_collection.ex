defmodule Routes.Specs.ContainerEnvelopeSimplePromoCollection do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["UserAgentValidator"],
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        query_params_allowlist: ["static"],
        examples: [
          %{
            path: "/container/envelope/simple-promo-collection/brandPalette/weatherLight/corePalette/light/enablePromoDescriptions/true/fontPalette/sansSimple/hasFetcher/true/home/weather/isUk/true/title/Features/urn/urn:bbc:tipo:list:a143d472-c30e-4458-9f3a-538e90a5fd70/withContainedPromos/false?static=true",
            headers: %{"user-agent" => "MozartFetcher"}
          }
        ]
      }
    }
  end
end
