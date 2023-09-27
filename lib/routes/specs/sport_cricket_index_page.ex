defmodule Routes.Specs.SportCricketIndexPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/cricket/womens.app", "/sport/cricket/counties.app", "/sport/cricket.app"]
      }
    }
  end
end
