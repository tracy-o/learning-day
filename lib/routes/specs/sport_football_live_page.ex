defmodule Routes.Specs.SportFootballLivePage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/live/football/66160387", "/sport/live/football/66160387.app", "/sport/live/football/66160387/page/2", "/sport/live/football/66160387/page/2.app"]
      }
    }
  end
end
