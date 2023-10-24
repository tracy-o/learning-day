defmodule Routes.Specs.LiveHub do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-live",
        email: "D&ESportLiveTeam@bbc.co.uk",
        team: "Live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Hub+Runbook",
        platform: "Webcore",
        examples: [
          "/live/hub"
        ]
      }
    }
  end
end
