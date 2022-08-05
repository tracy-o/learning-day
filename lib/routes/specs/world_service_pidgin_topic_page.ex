defmodule Routes.Specs.WorldServicePidginTopicPage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: ["WorldServiceTopicsGuid"],
      query_params_allowlist: query_params_allowlist(production_env)
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["page", "renderer_env"]
end
