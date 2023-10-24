defmodule Routes.Specs.NewsroundArticlePage do
  def specification do
    %{
      specs: %{
        email: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"],
        examples: ["/newsround/61545299"]
      }
    }
  end
end
