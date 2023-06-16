defmodule Routes.Specs.SportMajorIndexPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/tennis", "/sport/tennis.app", "/sport/golf", "/sport/golf.app", "/sport/formula1", "/sport/formula1.app", "/sport/cycling", "/sport/cycling.app", "/sport/athletics", "/sport/athletics.app", "/sport.app"]
      }
    }
  end
end
