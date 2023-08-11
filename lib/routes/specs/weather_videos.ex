defmodule Routes.Specs.WeatherVideos do
  def specification(production_env) do
    %{
      specs: %{
        owner: "sfv-team@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
        platform: "Webcore",
        query_params_allowlist: query_params_allowlist(production_env),
        examples: ["/weather/videos/cpvx015ypvxo", "/weather/av/64475513"]
      }
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["features"]
end
