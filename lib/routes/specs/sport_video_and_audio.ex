defmodule Routes.Specs.SportVideoAndAudio do
  def specs do
    %{
      owner: "sfv-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: MozartSport,
      pipeline: ["HTTPredirect", "SportVideosPlatformDiscriminator"]
    }
  end
end
