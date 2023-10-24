defmodule Routes.Specs.SportAmp do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartSimorgh",
        examples: ["/sport/football/56064289.json?morph_env=live&renderer_env=live", "/sport/football/56064289.amp?morph_env=live&renderer_env=live", "/sport/50562296.json?morph_env=live&renderer_env=live", "/sport/50562296.amp?morph_env=live&renderer_env=live"]
      }
    }
  end
end
