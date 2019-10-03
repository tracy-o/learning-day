defmodule Routes.Specs.CBeebiesSearch do
  def specs do
    %{
      owner: "belfrage-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias"],
      resp_pipeline: [],
    }
  end
end
