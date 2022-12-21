defmodule Routes.Specs.WorldServiceKyrgyzLivePage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      query_params_allowlist: query_params_allowlist(production_env)
    }
  end

  defp query_params_allowlist("live"), do: ["page"]
  defp query_params_allowlist(_production_env), do: ["component_env",  "morph_env",  "page",  "renderer_env"]
end
