defmodule Belfrage.RouteSpec do
  alias __MODULE__
  alias Belfrage.Personalisation

  @allow_all_keys [:headers_allowlist, :query_params_allowlist]

  defstruct owner: "",
            pipeline: [],
            resp_pipeline: [],
            platform: nil,
            personalisation: nil,
            origin: nil,
            runbook: "",
            query_params_allowlist: [],
            headers_allowlist: [],
            caching_enabled: true,
            language_from_cookie: false,
            circuit_breaker_error_threshold: nil

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
    |> remove_placeholder()
    |> Map.put(:loop_id, name)
    |> Personalisation.transform_route_spec()
  end

  def merge_specs(platform_specs, route_specs) do
    route_spec = Map.merge(platform_specs, route_specs, &merge_key/3)

    struct(RouteSpec, route_spec)
  end

  def remove_placeholder(specs) do
    specs
    |> check_and_update_spec(:pipeline)
    |> check_and_update_spec(:resp_pipeline)
  end

  defp check_and_update_spec(specs, key) do
    if Map.has_key?(specs, key) do
      Map.update!(specs, key, fn x -> x -- [:_routespec_pipeline_placeholder] end)
    end
  end

  def merge_key(key, _platform_value = "*", _route_value) when key in @allow_all_keys do
    "*"
  end

  def merge_key(:pipeline, platform_pipeline, routespec_pipeline)
      when is_list(platform_pipeline) and is_list(routespec_pipeline) do
    alter_pipeline(platform_pipeline, routespec_pipeline)
  end

  def merge_key(:resp_pipeline, platform_pipeline, routespec_pipeline)
      when is_list(platform_pipeline) and is_list(routespec_pipeline) do
    alter_pipeline(platform_pipeline, routespec_pipeline)
  end

  def merge_key(_key, platform_list_value, route_list_value)
      when is_list(platform_list_value) and is_list(route_list_value) do
    platform_list_value ++ route_list_value
  end

  def merge_key(_any_key, _platform_value, route_value) do
    route_value
  end

  defp alter_pipeline(platform_pipeline, routespec_pipeline) do
    if :_routespec_pipeline_placeholder in platform_pipeline do
      Enum.flat_map(platform_pipeline, fn transformer ->
        if transformer == :_routespec_pipeline_placeholder, do: routespec_pipeline, else: [transformer]
      end)
    else
      routespec_pipeline
    end
  end
end
