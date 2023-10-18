defmodule Routes.Specs.WorldServiceUkchinaTopicPage do
  def specification(production_env) do
    %{
      preflight_pipeline: ["WorldServiceTopicsGuid"],
      specs: [
        %{
          platform: "Simorgh",
          request_pipeline: ["WorldServiceRedirect"],
          query_params_allowlist: query_params_allowlist(production_env),
          headers_allowlist: ["cookie-ckps_chinese"],
          examples: ["/ukchina/trad/topics/cgqnyy07pqyt", "/ukchina/trad/topics/cgqnyy07pqyt?page=2", "/ukchina/simp/topics/c1nq04kp0r0t", "/ukchina/simp/topics/c1nq04kp0r0t?page=2"]
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
