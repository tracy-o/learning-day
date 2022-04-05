defmodule Routes.Specs.Uploader do
  def specs("live") do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=183485635",
      platform: MorphRouter,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector", "ComToUKRedirect", "UploaderPlatformDiscriminator", "CircuitBreaker"]
    }
  end

  def specs(_production_env) do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=300173395",
      platform: Webcore,
      personalisation: "on",
      pipeline: ["ComToUKRedirect"]
    }
  end
end
