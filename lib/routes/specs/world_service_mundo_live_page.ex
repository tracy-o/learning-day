defmodule Routes.Specs.WorldServiceMundoLivePage do
  def specification(production_env) do
    %{
      preflight_pipeline: ["WorldServiceLivePlatformSelector"],
      specs: [
        %{
          platform: "MozartSimorgh",
          request_pipeline: ["WorldServiceRedirect"],
          examples: [] # we currently have no production env assets for this route
        },
        %{
          platform: "Simorgh",
          request_pipeline: ["WorldServiceRedirect"],
          query_params_allowlist: query_params_allowlist(production_env),
          examples: [] # we currently have no production env assets for this route
        }
      ]
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
