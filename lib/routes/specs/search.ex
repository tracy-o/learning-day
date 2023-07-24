defmodule Routes.Specs.Search do
  def specification(production_env) do
    %{
      specs: %{
        owner: "D+ESearchAndNavigationDev@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
        request_pipeline: ["ComToUKRedirect"],
        platform: "Webcore",
        query_params_allowlist: query_params_allowlist(production_env),
        caching_enabled: false,
        examples: ["/bitesize/search", "/cbbc/search", "/cbeebies/search", "/search"]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["q", "page", "d"]
  defp query_params_allowlist(_production_env), do: query_params_allowlist("live") ++ ["contentenv"]

end
