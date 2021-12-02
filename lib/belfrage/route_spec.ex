defmodule Belfrage.RouteSpec do
  alias __MODULE__
  alias Belfrage.Personalisation

  @allow_all_keys [:headers_allowlist, :query_params_allowlist]
  @pipeline_placeholder :_routespec_pipeline_placeholder

  defstruct loop_id: nil,
            owner: nil,
            slack_channel: nil,
            pipeline: [],
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
            circuit_breaker_error_threshold: nil

  def specs_for(name) do
    specs_for(name, Application.get_env(:belfrage, :production_environment))
  end

  def specs_for(name, env) do
    route_spec_module = Module.concat([Routes, Specs, name])

    route_spec =
      if route_spec_module.__info__(:functions)[:specs] == 1 do
        route_spec_module.specs(env)
      else
        route_spec_module.specs()
      end

    platform_spec = Module.concat([Routes, Platforms, route_spec.platform]).specs(env)

    route_spec
    |> Map.put(:loop_id, name)
    |> merge_specs(platform_spec)
    |> remove_placeholder()
    |> Personalisation.transform_route_spec()
  end

  def merge_specs(route_specs, platform_specs) do
    route_spec = Map.merge(platform_specs, route_specs, &merge_key/3)

    struct!(RouteSpec, route_spec)
  end

  def remove_placeholder(spec) do
    %RouteSpec{spec | pipeline: List.delete(spec.pipeline, @pipeline_placeholder)}
  end

  def merge_key(key, _platform_value = "*", _route_value) when key in @allow_all_keys do
    "*"
  end

  def merge_key(:pipeline, platform_pipeline, routespec_pipeline)
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
