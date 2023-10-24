defmodule Routes.Specs.SportIndexPage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/get-inspired/activity-guides", "/sport/get-inspired/activity-guides.app", "/sport/get-inspired", "/sport/get-inspired.app", "/sport/africa", "/sport/africa.app"]
      }
    }
  end
end
