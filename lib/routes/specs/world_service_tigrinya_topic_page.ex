defmodule Routes.Specs.WorldServiceTigrinyaTopicPage do
  def specification(production_env) do
    %{
      preflight_pipeline: ["WorldServiceTopicsGuid"],
      specs: [
        %{
          platform: "Simorgh",
          request_pipeline: ["WorldServiceRedirect"],
          query_params_allowlist: query_params_allowlist(production_env),
          examples: ["/tigrinya/topics/c1gdqrg28zxt", "/tigrinya/topics/c1gdqrg28zxt?page=2"]
        },
         %{
          platform: "MozartNews",
          request_pipeline: ["WorldServiceRedirect"],
          query_params_allowlist: query_params_allowlist(production_env),
          examples: []
        }
      ]
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
