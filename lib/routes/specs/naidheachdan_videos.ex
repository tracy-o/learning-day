defmodule Routes.Specs.NaidheachdanVideos do
  def specification(production_env) do
    %{
      specs: %{
        email: "sfv-team@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
        platform: "Webcore",
        default_language: "gd",
        query_params_allowlist: query_params_allowlist(production_env),
        examples: ["/naidheachdan/fbh/53159144"]
      }
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["features"]

end
