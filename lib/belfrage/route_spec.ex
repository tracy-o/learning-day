defmodule Belfrage.RouteSpec do
  alias Belfrage.Personalisation
  alias Belfrage.Behaviours.Transformer

  @allowlists ~w(headers_allowlist query_params_allowlist cookie_allowlist)a
  @pipeline_placeholder :_routespec_pipeline_placeholder

  @type name :: String.t()
  @type platform :: String.t()

  defstruct platform: nil,
            team: nil,
            email: nil,
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
            xray_enabled: false,
            examples: []

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

    specification = call_specification_func(module, env)
    preflight_pipeline = Map.get(specification, :preflight_pipeline, [])
    specs = Map.get(specification, :specs)

    %{
      name: spec_name,
      preflight_pipeline: validate_pipeline(preflight_pipeline, spec_name, :preflight),
      specs: parse_specs(spec_name, specs, preflight_pipeline, env)
    }
  end

  @spec list_examples(String.t()) :: [map()]
  def list_examples(env \\ Application.get_env(:belfrage, :production_environment)) do
    list_route_specs(env)
    |> Enum.flat_map(&get_examples/1)
  end

  @spec get_examples(String.t() | map(), String.t()) :: map()
  def get_examples(%{name: spec_name, specs: specs}) do
    examples =
      for %{platform: platform_name, examples: examples} <- specs do
        for example <- examples, do: Map.merge(example, %{platform: platform_name, spec: spec_name})
      end

    :lists.append(examples)
  end

  def get_examples(spec_name, env \\ Application.get_env(:belfrage, :production_environment)) do
    get_route_spec(spec_name, env) |> get_examples()
  end

  defp parse_specs(spec_name, spec, preflight_pipeline, env) when is_map(spec) do
    parse_specs(spec_name, [spec], preflight_pipeline, env)
  end

  defp parse_specs(spec_name, specs, [], _env) when length(specs) > 1 do
    raise("Pre flight pipeline doesn't exist for #{spec_name}, but spec contains multiple Platforms.")
  end

  defp parse_specs(spec_name, specs, _preflight_pipeline, env) do
    specs
    |> Enum.map(&update_spec_with_platform(&1, spec_name, env))
    |> validate_unique_platforms(spec_name)
  end

  defp update_spec_with_platform(spec, spec_name, env) do
    platform = get_platform(spec.platform, env)

    spec
    |> Map.merge(merge_allowlists(platform, spec))
    |> Map.put(:request_pipeline, merge_validate_pipelines(:request_pipeline, spec, spec_name, platform))
    |> Map.put(:response_pipeline, merge_validate_pipelines(:response_pipeline, spec, spec_name, platform))
    |> Map.put(:examples, parse_examples(spec, platform))
    |> validate_spec_fields(spec_name, platform)
    |> Personalisation.maybe_put_personalised_route()
  end

  defp parse_examples(spec, platform) do
    case Map.get(spec, :examples, []) do
      [] -> []
      examples -> Enum.map(examples, &parse_example(&1, platform))
    end
  end

  defp parse_example(path, platform) when is_binary(path) do
    parse_example(%{path: path}, platform)
  end

  defp parse_example(example = %{path: path}, platform) do
    platform_example = Map.get(platform, :examples, %{})

    %{
      path: path,
      expected_status: Map.get(example, :expected_status, 200),
      request_headers:
        Map.merge(
          Map.get(platform_example, :request_headers, %{}),
          Map.get(example, :request_headers, %{})
        )
    }
  end

  defp get_platform(platform_name, env) do
    module = Module.concat([Routes, Platforms, platform_name])
    ensure_module_loaded(module)
    call_specification_func(module, env)
  end

  # Currently we use %RouteSpec{} struct as a spec fields validator.
  # This should be transformed to the json schema validation later.
  defp validate_spec_fields(spec, spec_name, platform) do
    try do
      struct!(__MODULE__, Map.merge(platform, spec)) |> Map.from_struct()
    catch
      _, reason -> raise "Invalid '#{inspect(spec_name)}' spec, error: #{inspect(reason)}"
    end
  end

  defp call_specification_func(module, env) do
    cond do
      function_exported?(module, :specification, 1) -> module.specification(env)
      function_exported?(module, :specification, 0) -> module.specification()
      true -> raise "Module '#{module}' must define a specification/0 or specification/1 function"
    end
  end

  defp merge_validate_pipelines(type, spec, spec_name, platform) do
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

    validate_pipeline(pipeline, spec_name, pipeline_to_transformer_type(type))
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
