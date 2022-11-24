defmodule Routes.Specs.NewsroundHomePagePreview do
  def specs do
    %{
      owner: "childrensfutureweb@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
      platform: Webcore,
      request_pipeline: ["ComToUKRedirect"]
    }
  end
end