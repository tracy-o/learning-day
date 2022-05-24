defmodule Routes.Specs.Uploader do
  def specs do
    %{
      owner: "D&EHomeParticipationTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=300173395",
      platform: Webcore,
      personalisation: "on",
      pipeline: ["HTTPredirect", "TrailingSlashRedirector", "ComToUKRedirect", "CircuitBreaker"]
    }
  end
end
