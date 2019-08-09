defmodule Routes.Specs.SportVideos do
  def specs do
    # TODO: this can be a struct with all the validations!
    %{
      owner: "DENewsFrameworksTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "LambdaOriginAliasTransformer", "ReplayedTrafficTransformer"],
      resp_pipeline: [],
    }
  end
end
