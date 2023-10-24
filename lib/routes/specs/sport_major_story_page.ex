defmodule Routes.Specs.SportMajorStoryPage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/tennis/56731414?morph_env=live&renderer_env=live", "/sport/tennis/56731414.app?morph_env=live&renderer_env=live", "/sport/cycling/56655734?morph_env=live&renderer_env=live", "/sport/cycling/56655734.app?morph_env=live&renderer_env=live", "/sport/athletics/56628151?morph_env=live&renderer_env=live", "/sport/athletics/56628151.app?morph_env=live&renderer_env=live", "/sport/50562296?morph_env=live&renderer_env=live", "/sport/50562296.app?morph_env=live&renderer_env=live"]
      }
    }
  end
end
