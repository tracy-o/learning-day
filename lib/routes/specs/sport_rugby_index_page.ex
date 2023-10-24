defmodule Routes.Specs.SportRugbyIndexPage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/rugby-union", "/sport/rugby-union.app", "/sport/rugby-league", "/sport/rugby-league.app"]
      }
    }
  end
end
