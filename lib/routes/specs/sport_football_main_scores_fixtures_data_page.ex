defmodule Routes.Specs.SportFootballMainScoresFixturesDataPage do
  def specification do
    %{
      preflight_pipeline: ["SportFootballScoresFixturesPointer"],
      specs: [
        %{
          slack_channel: "#help-sport",
          runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
          platform: "Webcore"
        },
        %{
          slack_channel: "#help-sport",
          runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
          platform: "MozartSport",
          examples: ["/sport/football/scores-fixtures"]
        }
      ]
    }
  end
end
