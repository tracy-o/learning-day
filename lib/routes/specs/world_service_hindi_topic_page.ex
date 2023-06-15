defmodule Routes.Specs.WorldServiceHindiTopicPage do
  def specification(production_env) do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect", "WorldServiceTopicsGuid"],
        query_params_allowlist: query_params_allowlist(production_env),
        examples: ["/hindi/topics/c6vzy709wvxt", "/hindi/topics/c6vzy709wvxt?page=2"]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
