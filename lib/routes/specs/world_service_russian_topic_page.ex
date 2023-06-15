defmodule Routes.Specs.WorldServiceRussianTopicPage do
  def specification(production_env) do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect", "WorldServiceTopicsGuid"],
        query_params_allowlist: query_params_allowlist(production_env),
        examples: ["/russian/topics/c50nzm54vzmt", "/russian/topics/c50nzm54vzmt?page=2"]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
