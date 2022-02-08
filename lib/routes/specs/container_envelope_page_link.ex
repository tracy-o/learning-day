defmodule Routes.Specs.ContainerEnvelopePageLink do
  def specs do
    %{
      owner: "DENewsElections@bbc.co.uk",
      platform: Webcore,
      pipeline: ["UserAgentValidator"],
      runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2021",
      query_params_allowlist: ["static"]
    }
  end
end
