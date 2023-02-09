defmodule Routes.Specs.ContainerEnvelopeSimplePromoCollection do
  def specs do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      platform: "Webcore",
      request_pipeline: ["UserAgentValidator"],
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      query_params_allowlist: ["static"]
    }
  end
end
