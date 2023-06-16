defmodule Routes.Specs.SportCricketIndexPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/cricket/womens", "/sport/cricket/womens.app", "/sport/cricket/counties", "/sport/cricket/counties.app", "/sport/cricket", "/sport/cricket.app"]
      }
    }
  end
end
