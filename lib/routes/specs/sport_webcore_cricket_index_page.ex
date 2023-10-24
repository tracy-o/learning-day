defmodule Routes.Specs.SportWebcoreCricketIndexPage do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        personalisation: "on",
        query_params_allowlist: ["page"],
        examples: ["/sport/cricket", "/sport/cricket/womens", "/sport/cricket/counties"]
      }
    }
  end
end
