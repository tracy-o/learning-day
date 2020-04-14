defmodule Belfrage.RouteSpec do
  def specs_for(name) do
    specs_for(name, Application.get_env(:belfrage, :production_environment))
  end

  def specs_for(name, env) do
    specs = Module.concat([Routes, Specs, name]).specs()

    Module.concat([Routes, Platforms, specs.platform]).specs(env)
    |> merge_specs(specs)
    |> Map.put(:loop_id, name)
  end

  def merge_specs(platform_specs, route_specs) do
    Map.merge(platform_specs, route_specs, &merge_key/3)
  end

  defp merge_key(:query_params_allowlist, _platform_value = "*", _route_value) do
    "*"
  end

  defp merge_key(_key, platform_list_value, route_list_value)
       when is_list(platform_list_value) and is_list(route_list_value) do
    platform_list_value ++ route_list_value
  end

  defp merge_key(_any_key, _platform_value, route_value) do
    route_value
  end
end
