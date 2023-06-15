defmodule Routes.Specs.SportFootballStoryPage do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/football/56064289?morph_env=live&renderer_env=live", "/sport/football/56064289.app?morph_env=live&renderer_env=live"]
      }
    }
  end
end
