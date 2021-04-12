defmodule Routes.Specs.ContainerEnvelopeTestContainers do
  def specs do
    %{
      owner: "d&ewebcorepresentationteam@bbc.co.uk",
      platform: Webcore,
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/Presentation+Layer+Run+Book#PresentationLayerRunBook-ContainerAPI",
      query_params_allowlist: ["q", "page", "scope", "filter", "static"]
    }
  end
end
