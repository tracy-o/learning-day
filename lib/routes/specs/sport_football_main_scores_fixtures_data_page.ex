defmodule Routes.Specs.SportFootballMainScoresFixturesDataPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        request_pipeline: ["SportFootballScoresFixturesPointer"],
        examples: ["/sport/football/scores-fixtures"]
      }
    }
  end
end
