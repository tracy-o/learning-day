defmodule Routes.Specs.SportTopicPage do
  def specification do
    %{
      specs: %{
        owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        query_params_allowlist: ["page"],
        personalisation: "on",
        examples: ["/sport/topics/cd61kendv7et"]
      }
    }
  end
end
