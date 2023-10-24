defmodule Routes.Specs.Search do
  def specification(production_env) do
    %{
      preflight_pipeline: ["BBCXWebcorePlatformSelector"],
      specs: [
        %{
          email: "D+ESearchAndNavigationDev@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
          request_pipeline: ["ComToUKRedirect"],
          platform: "Webcore",
          query_params_allowlist: query_params_allowlist(production_env),
          caching_enabled: false,
          examples: ["/bitesize/search", "/cbbc/search", "/cbeebies/search", "/search"]
        },
        %{
          platform: "BBCX",
          query_params_allowlist: query_params_allowlist(production_env),
          caching_enabled: false,
          examples: ["/search"]
        }
      ]
    }
  end

  defp query_params_allowlist("live"), do: ["q", "page", "d", "seqId"]
  defp query_params_allowlist(_production_env), do: query_params_allowlist("live") ++ ["contentenv"]
end
