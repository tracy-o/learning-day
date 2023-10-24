defmodule Routes.Specs.SportHorseRacingDataPage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/horse-racing/race/EHRP771835", "/sport/horse-racing/race/EHRP771835.app", "/sport/horse-racing/uk-ireland/results", "/sport/horse-racing/uk-ireland/results.app", "/sport/horse-racing/calendar", "/sport/horse-racing/calendar.app"]
      }
    }
  end
end
