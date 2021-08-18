defmodule Belfrage.RouteSpec do
  alias Belfrage.Personalisation

  @allow_all_keys [:headers_allowlist, :query_params_allowlist]

  def specs_for(name) do
    specs_for(name, Application.get_env(:belfrage, :production_environment))
  end

  def specs_for(name, env) do
    route_spec_module = Module.concat([Routes, Specs, name])

    specs =
      case route_spec_module.__info__(:functions)[:specs] == 1 do
        true -> route_spec_module.specs(env)
        false -> route_spec_module.specs()
      end

    Module.concat([Routes, Platforms, specs.platform]).specs(env)
    |> merge_specs(specs)
    |> Map.put(:loop_id, name)
    |> Personalisation.transform_route_spec()
  end

  def merge_specs(platform_specs, route_specs) do
    Map.merge(platform_specs, route_specs, &merge_key/3)
  end

  def merge_key(key, _platform_value = "*", _route_value) when key in @allow_all_keys do
    "*"
  end

  def merge_key(:pipeline, platform_pipeline, routespec_pipeline) when is_list(platform_pipeline) and is_list(routespec_pipeline) do
    if :routespec_placeholder in platform_pipeline do
      List.flatten(Enum.map(platform_pipeline, fn transformer -> if transformer == :routespec_placeholder, do: routespec_pipeline, else: transformer end))
    else
      routespec_pipeline
    end
  end

  def merge_key(_key, platform_list_value, route_list_value)
       when is_list(platform_list_value) and is_list(route_list_value) do
    platform_list_value ++ route_list_value
  end

  def merge_key(_any_key, _platform_value, route_value) do
    route_value
  end
end
