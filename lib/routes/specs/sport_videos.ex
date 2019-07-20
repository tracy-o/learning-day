defmodule Routes.Specs.SportVideos do
  def specs do
    IO.puts " in the sport video loop!"

    %{
      owner: "team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/mozart/Mozart+runbook",
      platform: "webcore",
      pipeline:  ["ReplayedTrafficTransformer"],
      resp_pipeline: [],
      ttl: "30s",
      timeout: "1000ms"
    }
  end
end
