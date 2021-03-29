defmodule Routes.Specs.ContainerEnvelopeScoreboard do
  def specs do
    %{
      owner: "DENewsElections@bbc.co.uk",
      platform: Webcore,
      runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Run+book+-+UK+2021"
    } # TODO: Add something (pipeline?) that enforces the user agent to match an allow-list
  end
end
