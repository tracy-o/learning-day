defmodule Routes.Specs.SportLiveGuide do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Live+Guide+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/live-guide/football.app", "/sport/live-guide/football", "/sport/live-guide", "/sport/live-guide.app"]
      }
    }
  end
end
