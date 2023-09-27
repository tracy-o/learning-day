defmodule Routes.Specs.SportWebcoreIndexPage do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        personalisation: "on",
        query_params_allowlist: ["page"],
        examples: ["/sport/rugby-union/welsh", "/sport/rugby-union/scottish", "/sport/rugby-union/irish", "/sport/northern-ireland/motorbikes", "/sport/northern-ireland/gaelic-games", "/sport/winter-sports", "/sport/motorsport", "/sport/disability-sport", "/sport/boxing", "/sport/basketball", "/sport/american-football", "/sport/olympics", "/sport/winter-olympics", "/sport/commonwealth-games"]
      }
    }
  end
end