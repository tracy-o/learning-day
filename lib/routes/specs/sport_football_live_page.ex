defmodule Routes.Specs.SportFootballLivePage do
  def specification do
    %{
      specs: %{
        owner: "#help-live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/live/football/23247541", "/sport/live/football/23247541.app", "/sport/live/football/23247541/page/2", "/sport/live/football/23247541/page/2.app"]
      }
    }
  end
end
