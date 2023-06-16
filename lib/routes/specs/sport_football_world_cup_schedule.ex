defmodule Routes.Specs.SportFootballWorldCupSchedule do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/SLS/Sport+Football+World+Cup+2022+Container+Run+Book",
        platform: "Webcore",
        examples: ["/sport/app-webview/football/world-cup/schedule", "/sport/football/world-cup/schedule"]
      }
    }
  end
end
