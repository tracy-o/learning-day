defmodule Routes.Specs.SportAlphaFootballLivePage do
    def specs do
      %{
        owner: "#help-live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Experience+on+Webcore+Run+Book",
        platform: Webcore,
        query_params_allowlist: ["page", "mode"]
      }
    end
  end