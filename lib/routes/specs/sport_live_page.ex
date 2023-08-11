defmodule Routes.Specs.SportLivePage do
  def specification do
    %{
      preflight_pipeline: ["SportLivePlatformSelector"],
      specs: [
        %{
          owner: "#help-live",
          runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Run+Book",
          platform: "MozartSport",
          examples: [
            "/sport/live/cricket/64958413", 
            "/sport/live/cricket/64958413/page/2", 
            "/sport/live/cricket/64958413/page/3.app", 
            "/sport/live/53024649", 
            "/sport/live/53024649.app", 
            "/sport/live/53024649/page/2.app"
          ]
        },
        %{
          owner: "#help-live",
          runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Experience+on+Webcore+Run+Book",
          platform: "Webcore",
          query_params_allowlist: ["page", "post"],
          examples: [] # we currently have no production assets on /sport/live/
        },
      ]
    }
  end
end
