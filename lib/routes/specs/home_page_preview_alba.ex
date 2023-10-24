defmodule Routes.Specs.HomePagePreviewAlba do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
        platform: "Webcore",
        default_language: "gd",
        personalisation: "on",
        examples: ["/homepage/preview/alba"]
      }
    }
  end
end
