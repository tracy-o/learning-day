defmodule Routes.Specs.SportRedirects do
  def specs do
    %{
      owner: "#help-sport",
      runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
      platform: MozartSport,
      pipeline: ["HTTPredirect"]
    }
  end
end
