defmodule Routes.Specs.WorldServiceSerbianTopicPage do
  def specification(production_env) do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect", "WorldServiceTopicsGuid"],
        query_params_allowlist: query_params_allowlist(production_env),
        headers_allowlist: ["cookie-ckps_serbian"],
        examples: ["/serbian/lat/topics/c5wzvzzz5vrt", "/serbian/lat/topics/c5wzvzzz5vrt?page=2", "/serbian/cyr/topics/cqwvxvvw9qrt", "/serbian/cyr/topics/cqwvxvvw9qrt?page=2"]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
