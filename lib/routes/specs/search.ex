defmodule Routes.Specs.Search do
  def specs(production_env) do
    %{
      owner: "D+ESearchAndNavigationDev@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
      request_pipeline: ["ComToUKRedirect"],
      platform: "Webcore",
      query_params_allowlist: query_params_allowlist(production_env),
      caching_enabled: false
    }
  end

  defp query_params_allowlist("live"), do: ["q", "page", "d"]
  defp query_params_allowlist(_production_env), do: query_params_allowlist("live") ++ ["contentenv"]

end
