defmodule Routes.Specs.PresTestPersonalised do
  def specs do
    %{
      owner: "D&EWebCorePresentationTeam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["q", "page", "scope", "filter", "personalisationMode"],
      personalisation: "test_only"
    }
  end
end
