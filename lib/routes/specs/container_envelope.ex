defmodule Routes.Specs.ContainerEnvelope do
  def specification do
    %{
      specs: %{
        owner: "d&ewebcorepresentationteam@bbc.co.uk",
        platform: "Webcore",
        runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/Presentation+Layer+Run+Book#PresentationLayerRunBook-ContainerAPI",
        query_params_allowlist: ["static"],
        request_pipeline: ["UserAgentValidator"],
        examples: ["/container/envelope/global-footer/hasFetcher/true"]
      }
    } # TODO: Add something (query string requirement?) that indicates this catch-all shouldn't be used in production
  end
end
