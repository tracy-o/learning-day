defmodule Routes.Specs.UploaderWorldService do
  def specs do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=183485635",
      platform: "MorphRouter",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
