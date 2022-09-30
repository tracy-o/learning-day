defmodule Routes.Specs.WelshSearch do
  def specs do
    %{
      owner: "D+ESearchAndNavigationDev@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
      request_pipeline: ["ComToUKRedirect"],
      platform: Webcore,
      query_params_allowlist: ["q", "page", "d"],
      default_language: "cy",
      caching_enabled: false
    }
  end
end
