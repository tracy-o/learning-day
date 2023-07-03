defmodule Routes.Specs.HomePage do
  def specification do
    %{
      preflight_pipeline: ["DotComHomepagePlatformSelector"],
      specs: [
        %{
          owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
          platform: "Webcore",
          personalisation: "on",
          fallback_write_sample: 0.5,
          examples: ["/"]
        },
        %{
          platform: "DotComHomepage"
        }
      ]
    }
  end
end
