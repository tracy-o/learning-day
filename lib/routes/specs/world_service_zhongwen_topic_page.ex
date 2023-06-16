defmodule Routes.Specs.WorldServiceZhongwenTopicPage do
  def specification(production_env) do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect", "WorldServiceTopicsGuid"],
        query_params_allowlist: query_params_allowlist(production_env),
        headers_allowlist: ["cookie-ckps_chinese"],
        examples: ["/zhongwen/trad/topics/cpydz21p02et", "/zhongwen/trad/topics/cpydz21p02et?page=2", "/zhongwen/simp/topics/c0dg90z8nqxt", "/zhongwen/simp/topics/c0dg90z8nqxt?page=2"]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
