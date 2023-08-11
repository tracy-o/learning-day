defmodule Routes.Specs.PresTestPersonalised do
  def specification do
    %{
      specs: %{
        owner: "D&EWebCorePresentationTeam@bbc.co.uk",
        platform: "Webcore",
        query_params_allowlist: ["q", "page", "personalisationMode"],
        personalisation: "test_only"
      }
    }
  end
end
