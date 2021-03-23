defmodule Routes.Specs.ContainerEnvelopeCatchAll do
  def specs do
    %{
      owner: "d&ewebcorepresentationteam@bbc.co.uk",
      platform: Webcore
    } # TODO: Add something (query string requirement?) that indicates this catch-all shouldn't be used in production
  end
end
