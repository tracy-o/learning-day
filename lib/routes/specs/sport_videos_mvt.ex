defmodule Routes.Specs.SportVideosMvt do
  def specs(production_env) do
    %{
      owner: "sfv-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: Webcore,
      query_params_allowlist: query_params_allowlist(production_env),
      mvt_project_id: 19730466715,
      caching_enabled: false,
      pipeline: ["DatalabMachineRecommendations"]
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["features"]
end
