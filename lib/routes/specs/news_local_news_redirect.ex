defmodule Routes.Specs.NewsLocalNewsRedirect do
  def specification do
    %{
      specs: %{
        owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        request_pipeline: ["LocalNewsTopicsRedirect"],
        platform: "MozartNews"
      }
    }
  end
end
