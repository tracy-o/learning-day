defmodule Routes.Specs.SportFootballGroupsAndSchedule do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/SLS/Sport+Football+Groups+and+Schedule+Container+Run+Book",
        platform: "Webcore",
        examples: ["/sport/football/world-cup/schedule.app", "/sport/football/world-cup/schedule"]
      }
    }
  end
end
