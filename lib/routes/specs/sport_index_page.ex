defmodule Routes.Specs.SportIndexPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/winter-olympics.app", "/sport/swimming", "/sport/swimming.app", "/sport/olympics.app", "/sport/horse-racing", "/sport/horse-racing.app", "/sport/get-inspired/activity-guides", "/sport/get-inspired/activity-guides.app", "/sport/get-inspired", "/sport/get-inspired.app", "/sport/commonwealth-games", "/sport/commonwealth-games.app", "/sport/africa", "/sport/africa.app"]
      }
    }
  end
end
