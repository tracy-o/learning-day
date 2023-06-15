defmodule Routes.Specs.SportHomeNationIndexPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/northern-ireland/motorbikes.app", "/sport/northern-ireland/gaelic-games.app", "/sport/northern-ireland.app", "/sport/england", "/sport/england.app"]
      }
    }
  end
end
