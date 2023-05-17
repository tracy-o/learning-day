defmodule Routes.Specs.SportWebcoreFootballLivePage do
  def specification do
    %{
      specs: %{
        owner: "#help-live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Experience+on+Webcore+Run+Book",
        platform: "Webcore",
        query_params_allowlist: ["page", "post"]
      }
    }
  end
end