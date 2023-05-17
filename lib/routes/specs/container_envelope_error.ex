defmodule Routes.Specs.ContainerEnvelopeError do
  def specification do
    %{
      specs: %{
        owner: "d&ewebcorepresentationteam@bbc.co.uk",
        platform: "Webcore",
        request_pipeline: ["UserAgentValidator"],
        runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/Presentation+Layer+Run+Book",
        query_params_allowlist: ["static"]
      }
    }
  end
end
