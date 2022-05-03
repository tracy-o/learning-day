defmodule Routes.Specs.CymrufywArticlePage do
  def specs do
    %{
      owner: "DENewsCardiff@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
      platform: Webcore,
      default_language: "cy",
      pipeline: ["ElectionBannerCouncilStory"]
    }
  end
end
