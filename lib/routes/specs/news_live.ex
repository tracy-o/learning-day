defmodule Routes.Specs.NewsLive do
  def specification(_production_env) do
    %{
      specs: %{
        owner: "#help-live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Run+Book",
        platform: "MozartNews",
        circuit_breaker_error_threshold: 500,
        request_pipeline: ["NewsLivePlatformDiscriminator"],
        query_params_allowlist: ["page"],
        examples: ["/news/live/uk-55930940/page/2", "/news/live/uk-55930940"]
      }
    }
  end
end