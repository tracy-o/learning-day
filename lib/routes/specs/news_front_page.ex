defmodule Routes.Specs.NewsFrontPage do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "Playground", "LambdaOriginAlias", "ReplayedTraffic"],
      resp_pipeline: [],
    }
  end
end
