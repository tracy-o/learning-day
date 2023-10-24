defmodule Routes.Specs.SportWebcoreFootballLivePage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Experience+on+Webcore+Run+Book",
        platform: "Webcore",
        query_params_allowlist: ["page", "post"],
        examples: ["/sport/football/live/cvpx5wr4nv8t.app", "/sport/football/live/cvpx5wr4nv8t"]
      }
    }
  end
end
