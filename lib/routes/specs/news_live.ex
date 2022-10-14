defmodule Routes.Specs.NewsLive do
  def specs(_production_env) do
    %{
      owner: "#help-live",
      runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Run+Book",
      platform: MozartNews,
      circuit_breaker_error_threshold: 500,
      request_pipeline: ["NewsLivePlatformDiscriminator"],
      query_params_allowlist: ["page"]
    }
  end
end