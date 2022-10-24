defmodule Belfrage.RouteSpec do
  alias Belfrage.Personalisation

  @platforms Routes.Platforms.list()
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
            etag: false

  def specs_for(name, env \\ Application.get_env(:belfrage, :production_environment)) do
    route_attrs =
      name
      |> get_route_spec_attrs(env)
      |> maybe_put_platform()

    route_attrs.platform
    |> get_platform_spec(env)
    |> update_with_route_attrs(route_attrs)
    |> Personalisation.maybe_put_personalised_route()
  end

  def get_route_spec_attrs(name, env) do
    [Routes, Specs, name]
    |> call_specs_func(env)
    |> Map.put(:route_state_id, name)
  end

  # maybe_put_platform/1 Takes a "spec" map and checks the :route_spec_id value.
  # If the :route_spec_id value has a Platform suffix
  # then the spec map is updated with the corresponding
  # platform atom.
  # Otherwise the original spec is returned.
  defp maybe_put_platform(spec) do
    maybe_put_platform(@platforms, spec)
  end

  defp maybe_put_platform([platform | rest], spec) do
    if String.ends_with?(spec.route_state_id, ".#{platform}") do
      Map.put(spec, :platform, String.to_atom("Elixir.#{platform}"))
    else
      maybe_put_platform(rest, spec)
    end
  end

  defp maybe_put_platform([], spec), do: spec

  defp call_specs_func(module_name, env) do
    module = Module.concat(module_name)

    case Code.ensure_loaded(module) do
      {:module, module} ->
        cond do
          function_exported?(module, :specs, 1) ->
            module.specs(env)

          function_exported?(module, :specs, 0) ->
            module.specs()

          true ->
            raise "Module #{module} must define a specs/0 or specs/1 function"
        end

      _ ->
        raise "Module #{module} doesn't exist"
    end
  end

  defp get_platform_spec(name, env) do
    struct!(__MODULE__, call_specs_func([Routes, Platforms, name], env))
  end

  defp update_with_route_attrs(spec = %__MODULE__{}, route_attrs) do
    route_overrides =
      route_attrs
      |> Map.merge(merge_allowlists(spec, route_attrs))
      |> Map.put(:request_pipeline, merge_pipelines(spec.request_pipeline, route_attrs[:request_pipeline]))
      |> Map.put(:response_pipeline, merge_pipelines(spec.response_pipeline, route_attrs[:response_pipeline]))

    struct!(spec, route_overrides)
  end

  defp merge_pipelines(platform_pipeline, route_pipeline) do
    if @pipeline_placeholder in platform_pipeline do
      Enum.flat_map(platform_pipeline, fn transformer ->
        if transformer == @pipeline_placeholder do
          route_pipeline || []
        else
          [transformer]
        end
      end)
    else
      route_pipeline || platform_pipeline
    end
  end

  defp merge_allowlists(spec, route_attrs) do
    Enum.reduce(@allowlists, %{}, fn attr, result ->
      spec_value = Map.fetch!(spec, attr)
      route_value = route_attrs[attr] || []

      value =
        if spec_value == "*" || route_value == "*" do
          "*"
        else
          spec_value ++ route_value
        end

      Map.put(result, attr, value)
    end)
  end
end
