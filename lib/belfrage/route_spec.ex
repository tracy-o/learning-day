defmodule Belfrage.RouteSpec do
  alias Belfrage.Personalisation
  alias Belfrage.Behaviours.Transformer

  @allowlists ~w(headers_allowlist query_params_allowlist cookie_allowlist)a
  @pipeline_placeholder :_routespec_pipeline_placeholder

  @type name :: String.t()
  @type platform :: String.t()

  defstruct name: nil,
            platform: nil,
            owner: nil,
            slack_channel: nil,
            request_pipeline: [],
            response_pipeline: [],
            personalisation: nil,
            # TODO: This probably shouldn't be an attribute of RouteSpec. It
            # currently is for convenience, but this value is specific to the
            # current request that's being processed by Belfrage and depends on
            # the environment. It's not a configuration option for a route and
            # so it should not be possible to set or override it in a route
            # spec module.
            personalised_route: false,
            # TODO: `origin` attribute can potentially be removed as it's
            # probably enough to just have `platform`. Each `platform` has its
            # own origin and there are no platforms with multiple origins, so
            # the origin could be determined from the platform when it comes to
            # making a request.
            origin: nil,
            runbook: nil,
            query_params_allowlist: [],
            headers_allowlist: [],
            cookie_allowlist: [],
            caching_enabled: true,
            signature_keys: %{skip: [], add: []},
            default_language: "en-GB",
            language_from_cookie: false,
            circuit_breaker_error_threshold: nil,
            mvt_project_id: 0,
            fallback_write_sample: 1,
            etag: false,
            xray_enabled: false

  @spec list_route_specs(String.t()) :: [map()]
  def list_route_specs(env \\ Application.get_env(:belfrage, :production_environment)) do
    list_spec_names()
    |> Enum.map(&get_route_spec(&1, env))
    |> validate_unique_specs()
  end

  @spec get_route_spec(String.t(), String.t()) :: map()
  def get_route_spec(spec_name, env \\ Application.get_env(:belfrage, :production_environment)) do
    module = Module.concat([Routes, Specs, spec_name])
    ensure_module_loaded(module)

    pre_flight_pipeline =
      call_pre_flight_pipeline_func(module, env)
      |> validate_pipeline(spec_name, :pre_flight)

    %{
      name: spec_name,
      pre_flight_pipeline: pre_flight_pipeline,
      specs: get_specs(spec_name, pre_flight_pipeline, module, env)
    }
  end

  defp get_specs(spec_name, pre_flight_pipeline, module, env) do
    specs =
      case call_specs_func(module, env) do
        spec when is_map(spec) ->
          [spec]

        [spec] ->
          [spec]

        specs when length(specs) > 1 ->
          if pre_flight_pipeline == [],
            do: raise("Pre flight pipeline doesn't exist for #{spec_name}, but spec contains multiple Platforms.")

          specs
      end

    specs
    |> Enum.map(&put_spec_name(&1, spec_name))
    |> Enum.map(&update_spec_with_platform(&1, env))
    |> validate_unique_platforms(spec_name)
  end

  defp update_spec_with_platform(spec, env) do
    platform = get_platform(spec.platform, env)

    spec
    |> Map.merge(merge_allowlists(platform, spec))
    |> Map.put(:request_pipeline, merge_validate_pipelines(:request_pipeline, platform, spec))
    |> Map.put(:response_pipeline, merge_validate_pipelines(:response_pipeline, platform, spec))
    |> to_route_spec_struct(platform)
    |> Personalisation.maybe_put_personalised_route()
  end

  defp get_platform(platform_name, env) do
    module = Module.concat([Routes, Platforms, platform_name])
    ensure_module_loaded(module)
    call_specs_func(module, env)
  end

  defp to_route_spec_struct(spec, platform) do
    try do
      struct!(__MODULE__, Map.merge(platform, spec))
    catch
      _, reason -> raise "Invalid '#{inspect(spec.name)}' spec, error: #{inspect(reason)}"
    end
  end

  defp put_spec_name(spec, spec_name) do
    Map.put(spec, :name, spec_name)
  end

  defp call_pre_flight_pipeline_func(module, env) do
    cond do
      function_exported?(module, :pre_flight_pipeline, 1) -> module.pre_flight_pipeline(env)
      function_exported?(module, :pre_flight_pipeline, 0) -> module.pre_flight_pipeline()
      true -> []
    end
  end

  defp call_specs_func(module, env) do
    cond do
      function_exported?(module, :specs, 1) -> module.specs(env)
      function_exported?(module, :specs, 0) -> module.specs()
      true -> raise "Module '#{module}' must define a specs/0 or specs/1 function"
    end
  end

  defp merge_validate_pipelines(type, platform, spec) do
    platform_pipeline = Map.get(platform, type, [])
    spec_pipeline = spec[type]

    pipeline =
      if @pipeline_placeholder in platform_pipeline do
        Enum.flat_map(platform_pipeline, fn transformer ->
          if transformer == @pipeline_placeholder do
            spec_pipeline || []
          else
            [transformer]
          end
        end)
      else
        spec_pipeline || platform_pipeline
      end

    validate_pipeline(pipeline, spec.name, pipeline_to_transformer_type(type))
  end

  defp merge_allowlists(platform, spec) do
    Enum.reduce(@allowlists, %{}, fn attr, result ->
      platform_value = Map.get(platform, attr, [])
      spec_value = Map.get(spec, attr, [])

      value =
        if platform_value == "*" || spec_value == "*" do
          "*"
        else
          platform_value ++ spec_value
        end

      Map.put(result, attr, value)
    end)
  end

  defp validate_pipeline(transformers, spec_name, type) do
    for name <- transformers,
        do: ensure_module_loaded(Transformer.get_transformer_callback(type, name))

    validate_unique(transformers, spec_name, "#{type}_transformers")
  end

  defp validate_unique_specs(specs) do
    spec_names = for spec <- specs, do: spec.name
    validate_unique(spec_names, "n/a", "spec names")
    specs
  end

  defp validate_unique_platforms(specs, spec_name) do
    platforms = for spec <- specs, do: spec.platform
    validate_unique(platforms, spec_name, "platforms in specs")
    specs
  end

  defp validate_unique(entities, spec_name, what) do
    case entities -- Enum.uniq(entities) do
      [] -> entities
      duplicates -> raise "#{what} are not unique, spec: '#{spec_name}', duplicates: #{inspect(duplicates)}"
    end
  end

  defp ensure_module_loaded(module) do
    case Code.ensure_loaded(module) do
      {:module, _} -> :ok
      {:error, _} -> raise "Module '#{module}' doesn't exist"
    end
  end

  defp pipeline_to_transformer_type(:request_pipeline), do: :request
  defp pipeline_to_transformer_type(:response_pipeline), do: :response

  defp list_spec_names() do
    {:ok, modules} = :application.get_key(:belfrage, :modules)
    module_path = "Routes.Specs."

    for module <- modules,
        String.starts_with?(Macro.to_string(module), module_path),
        do: String.trim_leading(Macro.to_string(module), module_path)
  end
end
