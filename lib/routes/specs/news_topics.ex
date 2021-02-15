defmodule Routes.Specs.NewsTopics do
  def specs do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: MozartNews,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector", "NewsTopicsPlatformDiscriminator"],
      query_params_allowlist: ["page"]
    }
  end
end
