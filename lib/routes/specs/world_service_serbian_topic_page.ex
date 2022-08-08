defmodule Routes.Specs.WorldServiceSerbianTopicPage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: ["WorldServiceTopicsGuid"],
      query_params_allowlist: query_params_allowlist(production_env),
      headers_allowlist: ["cookie-ckps_serbian"]
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["page", "renderer_env", "morph_env", "component_env"]
end
