defmodule Belfrage.RouteSpec do
  @allow_all_keys [:headers_allowlist, :query_params_allowlist]
  @production_environment Application.get_env(:belfrage, :production_environment)
  @allow_personalisation_map %{cookie_allowlist: ["ckns_atkn", "ckns_id"], headers_allowlist: ["x-id-oidc-signedin"]}

  def specs_for(name) do
    specs_for(name, @production_environment)
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
    |> interpolate_personalisation()
  end

  def interpolate_personalisation(route_spec) do
    if personalisation?(route_spec) do
      Map.merge(route_spec, @allow_personalisation_map)
    else
      route_spec
    end
  end

  def personalisation?(loop_id) when not is_map(loop_id) do
    personalisation?(specs_for(loop_id))
  end

  def personalisation?(route_spec) do
    case route_spec[:personalisation] do
      "on" -> true
      "test_only" -> @production_environment == "test"
      _ -> false
    end
  end

  def merge_specs(platform_specs, route_specs) do
    Map.merge(platform_specs, route_specs, &merge_key/3)
  end

  defp merge_key(key, _platform_value = "*", _route_value) when key in @allow_all_keys do
    "*"
  end

  defp merge_key(:pipeline, platform_list_value, route_list_value)
       when is_list(platform_list_value) and is_list(route_list_value) do
    route_list_value
  end

  defp merge_key(_key, platform_list_value, route_list_value)
       when is_list(platform_list_value) and is_list(route_list_value) do
    platform_list_value ++ route_list_value
  end

  defp merge_key(_any_key, _platform_value, route_value) do
    route_value
  end
end
