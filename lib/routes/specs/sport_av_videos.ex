defmodule Routes.Specs.SportAvVideos do
  def specs do
    %{
      owner: "sfv-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: Mozart,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector", "SportVideosPlatformDiscriminator"]
    }
  end
end