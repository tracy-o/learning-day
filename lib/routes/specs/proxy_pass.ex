defmodule Routes.Specs.ProxyPass do
  def specs do
    %{
      owner: "belfrage-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :origin_simulator,
      pipeline: ["ReplayedTrafficTransformer"],
      resp_pipeline: [],
    }
  end
end
