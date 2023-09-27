defmodule Routes.Specs.SportWebcoreVideoIndexPage do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        query_params_allowlist: ["page"],
        examples: ["/sport/cricket/video"]
      }
    }
  end
end