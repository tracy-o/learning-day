defmodule Routes.Specs.ArticlePage do
  def specs do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias"],
      resp_pipeline: [],
    }
  end
end
