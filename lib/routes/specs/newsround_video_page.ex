defmodule Routes.Specs.NewsroundVideoPage do
  def specification do
    %{
      specs: %{
        owner: "sfv-team@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"]
      }
    }
  end
end
