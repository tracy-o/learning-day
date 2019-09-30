defmodule Routes.Specs.CBeebiesFrontPage do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "Playground", "LambdaOriginAliasTransformer", "ReplayedTrafficTransformer"],
      resp_pipeline: [],
    }
  end
end
