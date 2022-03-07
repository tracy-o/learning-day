defmodule Routes.Specs.Search do
  def specs do
    %{
      owner: "D+ESearchAndNavigationDev@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
      pipeline: ["ComToUKRedirect"],
      platform: Webcore,
      query_params_allowlist: ["q", "page", "scope", "filter"],
      caching_enabled: false
    }
  end
end
