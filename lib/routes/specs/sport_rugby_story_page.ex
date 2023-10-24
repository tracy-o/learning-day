defmodule Routes.Specs.SportRugbyStoryPage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/rugby-union/56719025?morph_env=live&renderer_env=live", "/sport/rugby-union/56719025.app?morph_env=live&renderer_env=live", "/sport/rugby-league/56730320?morph_env=live&renderer_env=live", "/sport/rugby-league/56730320.app?morph_env=live&renderer_env=live"]
      }
    }
  end
end
