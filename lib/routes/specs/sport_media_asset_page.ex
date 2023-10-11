defmodule Routes.Specs.SportMediaAssetPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/football/fa-cup/video.app", "/sport/cricket/video.app"]
      }
    }
  end
end
