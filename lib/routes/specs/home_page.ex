defmodule Routes.Specs.HomePage do
  def specs do
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "LambdaOriginAliasTransformer", "ReplayedTrafficTransformer"],
      resp_pipeline: [],
    }
  end
end
