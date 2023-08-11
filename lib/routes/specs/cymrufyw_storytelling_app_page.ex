defmodule Routes.Specs.CymrufywStorytellingAppPage do
  def specification do
    %{
      specs: %{
        owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Optimo+Articles+Runbook",
        platform: "Webcore",
        default_language: "cy",
        request_pipeline: ["ElectionBannerCouncilStory"],
        examples: ["/cymrufyw/erthyglau/ce56v6pk615o.app"]
      }
    }
  end
end
