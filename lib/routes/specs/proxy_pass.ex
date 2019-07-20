defmodule Routes.Specs.ProxyPass do
  def specs do
    %{
      owner: "belfrage-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/belfrage/Belfrage+runbook",
      platform: "OriginSimulator",
      pipeline: ["ReplayedTrafficTransformer"],
      resp_pipeline: [],
      ttl: "30s",
      timeout: "1000ms"
    }
  end
end
