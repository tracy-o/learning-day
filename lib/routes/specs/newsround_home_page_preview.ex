defmodule Routes.Specs.NewsroundHomePagePreview do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"],
        examples: ["/homepage/newsround/preview"]
      }
    }
  end
end
