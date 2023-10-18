defmodule Routes.Specs.WorldServiceZhongwenTopicPage do
  def specification(production_env) do
    %{
      preflight_pipeline: ["WorldServiceTopicsGuid"],
      specs: [
        %{
          platform: "Simorgh",
          request_pipeline: ["WorldServiceRedirect"],
          query_params_allowlist: query_params_allowlist(production_env),
          examples: ["/zhongwen/trad/topics/cpydz21p02et", "/zhongwen/trad/topics/cpydz21p02et?page=2", "/zhongwen/simp/topics/c0dg90z8nqxt", "/zhongwen/simp/topics/c0dg90z8nqxt?page=2"]
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
