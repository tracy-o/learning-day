defmodule Routes.Specs.SportFormula1StoryPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/formula1/56604356?morph_env=live&renderer_env=live", "/sport/formula1/56604356.app?morph_env=live&renderer_env=live"]
      }
    }
  end
end
