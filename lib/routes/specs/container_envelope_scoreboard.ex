defmodule Routes.Specs.ContainerEnvelopeScoreboard do
  def specs do
    %{
      owner: "DENewsElections@bbc.co.uk",
      platform: Webcore
    } # TODO: Add something (pipeline?) that enforces the user agent to match an allow-list
  end
end
