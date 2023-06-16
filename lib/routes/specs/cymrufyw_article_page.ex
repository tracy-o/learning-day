defmodule Routes.Specs.CymrufywArticlePage do
  def specification do
    %{
      specs: %{
        owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
        platform: "Webcore",
        default_language: "cy",
        request_pipeline: ["ElectionBannerCouncilStory"],
        examples: ["/cymrufyw/52998018", "/cymrufyw/52995676", "/cymrufyw/etholiad-2017-39407507"]
      }
    }
  end
end
