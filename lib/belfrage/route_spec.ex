defmodule Belfrage.RouteSpec do
  alias Belfrage.Personalisation
  alias Belfrage.Behaviours.Transformer

  @allowlists ~w(headers_allowlist query_params_allowlist cookie_allowlist)a
  @pipeline_placeholder :_routespec_pipeline_placeholder

  defstruct route_state_id: nil,
            owner: nil,
            slack_channel: nil,
            request_pipeline: [],
            response_pipeline: [],
            platform: nil,
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
            throughput: 100,
            mvt_project_id: 0,
            mvt_seen: %{},
            fallback_write_sample: 1,
            etag: false,
            xray_enabled: false

  @type route_state_id :: String.t()

  @spec make_route_state_id(String.t(), String.t()) :: route_state_id()
  def make_route_state_id(spec_name, platform) do
    "#{spec_name}.#{platform}"
  end

  @spec list_route_specs(String.t()) :: [RouteSpec.t()]
  def list_route_specs(env \\ Application.get_env(:belfrage, :production_environment)) do
    list_spec_names()
    |> Enum.map(&get_specs(&1, env))
    |> :lists.append()
    |> Enum.map(&update_spec_with_platform(&1, env))
    |> validate_unique_specs()
  end

  # get_route_spec/2 interface should be removed as it is used for tests only
  #
  @spec get_route_spec(route_state_id() | {String.t(), String.t()}, String.t()) :: RouteSpec.t() | nil
  def get_route_spec(_route_state_id, env \\ Application.get_env(:belfrage, :production_environment))

  def get_route_spec(route_state_id, env) when is_binary(route_state_id) do
    [spec_name, platform] = String.split(route_state_id, ".")
    get_route_spec({spec_name, platform}, env)
  end

  def get_route_spec({spec_name, platform}, env) do
    found_specs =
      for spec <- get_specs(spec_name, env),
          spec.platform == platform,
          do: update_spec_with_platform(spec, env)

    case found_specs do
      [spec] -> spec
      [] -> nil
    end
  end

  defp get_specs(spec_name, env) do
    module = Module.concat([Routes, Specs, spec_name])

    case call_specs_func(module, env) do
      spec when is_map(spec) -> [put_route_state_id(spec, spec_name)]
      specs when is_list(specs) -> Enum.map(specs, &put_route_state_id(&1, spec_name))
    end
  end

  defp update_spec_with_platform(spec, env) do
    platform = get_platform(spec.platform, env)

    spec
    |> Map.merge(merge_allowlists(platform, spec))
    |> Map.put(:request_pipeline, merge_validate_pipelines(:request_pipeline, platform, spec))
    |> Map.put(:response_pipeline, merge_validate_pipelines(:response_pipeline, platform, spec))
    |> to_struct(platform)
    |> Personalisation.maybe_put_personalised_route()
  end

  defp get_platform(platform_name, env) do
    module = Module.concat([Routes, Platforms, platform_name])
    call_specs_func(module, env)
  end

  defp to_struct(route_spec_map, platform) do
    try do
      struct!(__MODULE__, Map.merge(platform, route_spec_map))
    catch
      _kind, reason -> raise "Invalid '#{route_spec_map.route_state_id}' spec, error: #{inspect(reason)}"
    end
  end

  defp put_route_state_id(spec = %{platform: platform}, spec_name) do
    Map.put(spec, :route_state_id, make_route_state_id(spec_name, platform))
  end

  defp call_specs_func(module, env) do
    ensure_module_loaded(module)

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

    validate_pipeline(spec.route_state_id, pipeline_to_transformer_type(type), pipeline)
    pipeline
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

  defp validate_unique_specs(specs) do
    route_state_ids = for spec <- specs, do: spec.route_state_id

    case route_state_ids -- Enum.uniq(route_state_ids) do
      [] -> specs
      non_unique_ids -> raise "Specs are not unique: #{inspect(non_unique_ids)}}"
    end
  end

  defp validate_pipeline(route_state_id, type, transformers) do
    for name <- transformers,
        do: ensure_module_loaded(Transformer.get_transformer_callback(type, name))

    ensure_unique_transformers(route_state_id, type, transformers)
  end

  defp ensure_unique_transformers(route_state_id, type, transformers) do
    case Enum.uniq(transformers -- Enum.uniq(transformers)) do
      [] ->
        :ok

      duplicates ->
        type = Atom.to_string(type)

        raise "#{route_state_id} contains the following duplicated transformers in the #{type}_pipeline : #{inspect(duplicates)}"
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
