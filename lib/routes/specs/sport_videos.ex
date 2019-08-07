defmodule Routes.Specs.SportVideos do
  def specs do
    # TODO: this can be a struct with all the validations!
    %{
      owner: "team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/mozart/Mozart+runbook",
      platform: :webcore,
      pipeline: ["HTTPredirect", "LambdaOriginAliasTransformer", "ReplayedTrafficTransformer"],
      resp_pipeline: [],
    }
  end
end
