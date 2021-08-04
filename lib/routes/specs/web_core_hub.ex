defmodule Routes.Specs.WebCoreHub do
  def specs(production_env) do
    %{
      owner: "D&EWebCorePresentationTeam@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: query_params_allowlist(production_env)
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["branch"]
end
