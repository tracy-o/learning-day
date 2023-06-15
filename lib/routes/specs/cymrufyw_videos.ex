defmodule Routes.Specs.CymrufywVideos do
  def specification(production_env) do
    %{
      specs: %{
        owner: "sfv-team@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
        platform: "Webcore",
        default_language: "cy",
        query_params_allowlist: query_params_allowlist(production_env)
      }
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["features"]

end
