defmodule Routes.Specs.SportWebcoreIndexPage do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
        platform: "Webcore",
        personalisation: "on",
        query_params_allowlist: ["page"],
        examples: ["/sport/wales", "/sport/scotland", "/sport/rugby-union/welsh", "/sport/rugby-union/scottish", "/sport/rugby-union/irish", "/sport/northern-ireland/motorbikes", "/sport/northern-ireland/gaelic-games", "/sport/northern-ireland", "/sport/football/welsh", "/sport/football/scottish", "/sport/football/irish"]
      }
    }
  end
end