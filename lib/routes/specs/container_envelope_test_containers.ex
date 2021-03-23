defmodule Routes.Specs.ContainerEnvelopeTestContainers do
  def specs do
    %{
      owner: "d&ewebcorepresentationteam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["q", "page", "scope", "filter"]
    }
  end
end
