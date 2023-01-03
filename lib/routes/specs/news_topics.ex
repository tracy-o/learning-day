defmodule Routes.Specs.NewsTopics do
  def specs do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: "Webcore",
      query_params_allowlist: ["page"],
      request_pipeline: ["NewsTopicsPlatformDiscriminator"],
      personalisation: "test_only"
    }
  end
end
