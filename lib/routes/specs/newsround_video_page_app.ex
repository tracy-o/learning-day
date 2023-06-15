defmodule Routes.Specs.NewsroundVideoPageAppPage do
    def specs do
      %{
        owner: "sfv-team@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"]
      }
    end
  end