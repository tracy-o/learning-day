defmodule Routes.Specs.SportWebcoreFootballSubIndexPage do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        personalisation: "on",
        query_params_allowlist: ["page"],
        examples: ["/sport/football/welsh", "/sport/football/scottish", "/sport/football/irish", "/sport/football/world-cup"]
      }
    }
  end
end