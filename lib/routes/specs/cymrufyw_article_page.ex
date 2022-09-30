defmodule Routes.Specs.CymrufywArticlePage do
  def specs do
    %{
      owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
      platform: Webcore,
      default_language: "cy",
      request_pipeline: ["ElectionBannerCouncilStory"]
    }
  end
end
