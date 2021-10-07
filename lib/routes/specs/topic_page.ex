defmodule Routes.Specs.TopicPage do
  def specs do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: Webcore,
      query_params_allowlist: ["page"],
      personalisation: "on"
    }
  end
end
