defmodule Routes.Specs.SportCricketStoryPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/cricket/56734095?morph_env=live&renderer_env=live", "/sport/cricket/56734095.app?morph_env=live&renderer_env=live"]
      }
    }
  end
end
