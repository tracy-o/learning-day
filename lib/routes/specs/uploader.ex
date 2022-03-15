defmodule Routes.Specs.Uploader do
  def specs("live") do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=183485635",
      platform: MorphRouter,
      pipeline: ["TrailingSlashRedirector", "ComToUKRedirect"]
    }
  end

  # When the Webcore Uploader runbook has been created, the runbook link will need updating.
  def specs(_production_env) do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=183485635",
      platform: Webcore,
      personalisation: "on",
      pipeline: ["TrailingSlashRedirector", "ComToUKRedirect"]
    }
  end
end
