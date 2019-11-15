defmodule Routes.Specs.SportVideos do
  def specs do
    # TODO: this can be a struct with all the validations!
    %{
      owner: "sfv-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias"],
      resp_pipeline: [],
    }
  end
end
