defmodule Routes.Specs.WorldServiceSerbianTopicPage do
  def specs(production_env) do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect", "WorldServiceTopicsGuid"],
      query_params_allowlist: query_params_allowlist(production_env),
      headers_allowlist: ["cookie-ckps_serbian"]
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
