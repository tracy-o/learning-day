defmodule Routes.Specs.NewsLive do
  def specification do
    %{
      preflight_pipeline: ["NewsLivePlatformSelector"],
      specs: [
        %{
          slack_channel: "#help-live",
          runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Run+Book",
          platform: "MozartNews",
          examples: [
            "/news/live/uk-55930940",
            "/news/live/uk-55930940/page/2",
          ]
        },
        %{
          slack_channel: "#help-live",
          runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Experience+on+Webcore+Run+Book",
          platform: "Webcore",
          query_params_allowlist: ["page", "post"],
          examples: [] # we currently have no production env assets for this route
        },
      ]
    }
  end
end
