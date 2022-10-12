defmodule Routes.Specs.NewsroundVideoPage do
  def specs do
    %{
      owner: "childrensfutureweb@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: Webcore,
      pipeline: ["ComToUKRedirect"]
    }
  end
end
