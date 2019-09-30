defmodule Routes.Specs.WebShell do
  def specs do
    %{
      owner: "simon.scarfe@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "Playground", "LambdaOriginAliasTransformer", "ReplayedTrafficTransformer"],
      resp_pipeline: [],
    }
  end
end
