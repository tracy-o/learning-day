defmodule Routes.Specs.SportFootballMainScoresFixturesDataPageInApps do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/football/scores-fixtures.app"]
      }
    }
  end
end
