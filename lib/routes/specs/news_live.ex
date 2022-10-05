defmodule Routes.Specs.NewsLive do
  def specs(production_env) do
    %{
      owner: "#help-live",
      runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Run+Book",
      platform: MozartNews,
      circuit_breaker_error_threshold: 500,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["page"]
    }
  end

  def pipeline(_production_environment) do
    ["NewsLivePlatformDiscriminator"]
  end
end