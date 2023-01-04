# This is a copy of RoutefileTest.
# TODO: look at how we can run tests on all routefiles.

defmodule Routes.SportRoutefileTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper, only: [stub_origins: 0]

  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  alias Routes.Routefiles.Sport.Test, as: Routefile

  @platforms Routes.Platforms.list()

  @moduletag :routes_test

  @redirect_statuses Application.get_env(:belfrage, :redirect_statuses)

  @routes Routefile.routes()

  @examples Enum.flat_map(@routes, fn {matcher, %{examples: examples} = spec} ->
              Enum.map(examples, fn example ->
                example_path =
                  case example do
                    {path, _status_code} -> path
                    path -> path
                  end

                {matcher, spec, example_path}
              end)
            end)

  describe "routes" do
    test "matcher is prefixed with a '/'" do
      validate(@routes, fn {matcher, _} ->
        if String.starts_with?(matcher, "/") do
          :ok
        else
          {:error, "#{matcher} must start with a '/'"}
        end
      end)
    end

    test "route spec for 'test' env is valid" do
      env = "test"

      validate(@routes, fn
        # If the :platform attribute is not an actual platform, then
        # we simply validate the route as we cannot validate the
        # route spec or transformers. This is because the :platform
        # attribute is then expected to be a platform selector, which
        # requires a %Struct to select the platform. Given that we
        # are simply iterating through a list of routes, we do not
        # have access to the %Struct and therefore cannot select the
        # platform and build the route state id.
        {matcher, route = %{platform: platform}} when platform not in @platforms ->
          validate_required_attrs_in_route(matcher, route, env)

        {matcher, %{using: id, platform: platform}} ->
          spec = Belfrage.RouteSpec.get_spec(id, platform, env)

          with :ok <- validate_required_attrs_in_route_spec(matcher, spec, env),
               :ok <- validate_transformers(matcher, spec, env) do
            validate_platform_transformers(matcher, spec, env)
          end
      end)
    end

    test "route spec for 'live' env is valid" do
      env = "live"

      validate(@routes, fn
        {matcher, route = %{platform: platform, only_on: nil}} when platform not in @platforms ->
          validate_required_attrs_in_route(matcher, route, env)

        {matcher, %{using: id, platform: platform, only_on: nil}} ->
          spec = Belfrage.RouteSpec.get_spec(id, platform, env)

          with :ok <- validate_required_attrs_in_route_spec(matcher, spec, env),
               :ok <- validate_transformers(matcher, spec, env) do
            validate_platform_transformers(matcher, spec, env)
          end

        _ ->
          :ok
      end)
    end

    test "example is prefixed with a '/'" do
      validate(@examples, fn {matcher, _, example} ->
        if String.starts_with?(example, "/") do
          :ok
        else
          {:error, "Example #{example} for route #{matcher} must start with a '/'"}
        end
      end)
    end

    test "example is routed correctly" do
      stub_origins()

      @examples
      |> start_route_states()
      |> Enum.reject(fn {matcher, _, _} -> matcher == "/*any" end)
      |> validate(fn
        {matcher, %{platform: platform, using: spec_name}, example} when platform in @platforms ->
          conn = make_call(:get, example)
          plug_route = plug_route(conn)
          route_state_id = "#{spec_name}.#{platform}"

          if conn.assigns.route_spec == route_state_id do
            :ok
          else
            {:error,
             "Example #{example} for route #{matcher} is not routed to #{route_state_id}, but to #{conn.assigns.route_spec}"}
          end

          # An example may be routed to an incorrect route with the same route spec
          # as the expected route.
          #
          # Given this, below we check that the matched route stored in conn.private.plug_route
          # is the expected route.
          if plug_route == matcher do
            :ok
          else
            {:error, "Example #{example} for route #{matcher} has been routed to #{plug_route}"}
          end

        {matcher, %{platform: _platform, using: spec_name}, example} ->
          conn = make_call(:get, example)

          if String.starts_with?(conn.assigns.route_spec, spec_name) do
            :ok
          else
            {:error,
             "Example #{example} for route #{matcher} that uses a platform selector is not routed to a route spec that starts with #{spec_name}, but to #{conn.assigns.route_spec}"}
          end
      end)
    end

    test "proxy-pass examples are routed correctly" do
      start_supervised!({RouteState, "ProxyPass.OriginSimulator"})

      @examples
      |> Enum.filter(fn {matcher, _, _} -> matcher == "/*any" end)
      |> validate(fn {matcher, _, example} ->
        conn = make_call(:get, example)

        if conn.status == 404 && conn.resp_body =~ "404" do
          :ok
        else
          {:error,
           "Example #{example} for route #{matcher} is not routed correctly. Response status: #{conn.status}. Body: #{conn.resp_body}"}
        end
      end)
    end
  end

  describe "redirects" do
    test "location does not end with a *" do
      validate(Routefile.redirects(), fn {from, to, _} ->
        if String.ends_with?(to, "*") do
          {:error, "Location in redirect from #{from} to #{to} must not end with a '*'"}
        else
          :ok
        end
      end)
    end

    test "status is a redirect" do
      validate(Routefile.redirects(), fn {from, to, status} ->
        if status in @redirect_statuses do
          :ok
        else
          {:error,
           "Redirect from #{from} to #{to} has invalid status #{status} (must have one of #{@redirect_statuses})"}
        end
      end)
    end
  end

  describe "for routes that arent supported" do
    test "when the request is a GET request" do
      Application.put_env(:belfrage, :production_environment, "live")

      conn = make_call(:get, "/a_route_that_will_not_match")

      assert conn.status == 404
      assert conn.resp_body =~ "404"

      Application.put_env(:belfrage, :production_environment, "test")
    end

    test "when the request is a POST request" do
      conn = make_call(:post, "/a_route_that_will_not_match")

      assert conn.status == 405
      assert conn.resp_body =~ "405"
    end
  end

  defp make_call(method, path) do
    conn(method, path) |> Router.call(routefile: Routefile)
  end

  defp validate(items, validator) do
    errors =
      items
      |> Enum.map(validator)
      |> Enum.reduce([], fn el, acc ->
        case el do
          {:error, error} ->
            [error | acc]

          _ ->
            acc
        end
      end)

    unless errors == [] do
      errors
      |> Enum.map_join("\n", &"* #{&1}")
      |> flunk()
    end
  end

  defp validate_required_attrs_in_route(matcher, route, env) do
    cond do
      # If the name of the RouteSpec in the :using attribute has a platform
      # suffix, then we return an error tuple.
      #
      # This is because the :platform key in the route should be used
      # to later determine the platform suffix of the RouteSpec id.
      has_platform_suffix?(route) ->
        {:error,
         "Route #{matcher} has a route spec that is suffixed with a Platform for #{env}.\n Please remove the suffix and ensure that there is a :platform attribute in the route."}

      # If the platform attribute has a :platform key
      # that is neither a Platform nor a Platform Selector ending
      # in "PlatformSelector", then we raise a error. This is to
      # enforce the said convention.
      has_platform_key?(route) and not selector_or_platform?(route.platform) ->
        {:error,
         ~s(Route #{matcher} has a :platform attribute that is not a Platform Selector or Platform for #{env}.\n Please provide a :platform attribute that is a Platform, or a Platform Selector that ends with "PlatformSelector".)}

      true ->
        :ok
    end
  end

  defp validate_required_attrs_in_route_spec(matcher, spec, env) do
    required_attrs = ~w[platform request_pipeline circuit_breaker_error_threshold origin]a
    missing_attrs = required_attrs -- Map.keys(spec)

    if missing_attrs != [] do
      {:error, "Route #{matcher} doesn't have required attrs #{inspect(missing_attrs)} in route spec for #{env}"}
    else
      :ok
    end
  end

  defp validate_transformers(matcher, spec, env) do
    invalid_transformers =
      Enum.filter(spec.request_pipeline, fn transformer ->
        match?({:error, _}, Code.ensure_compiled(Module.concat([Belfrage, RequestTransformers, transformer])))
      end)

    duplicate_transformers = Enum.uniq(spec.request_pipeline -- Enum.uniq(spec.request_pipeline))

    cond do
      invalid_transformers != [] ->
        {:error,
         "Route #{matcher} contains invalid transformers in the request_pipeline on #{env}: #{inspect(invalid_transformers)}"}

      duplicate_transformers != [] ->
        {:error,
         "Route #{matcher} contains duplicate transformers in the request_pipeline on #{env}: #{inspect(duplicate_transformers)}"}

      env == "live" && "DevelopmentRequests" in spec.request_pipeline ->
        {:error, "Route #{matcher} contains DevelopmentRequests transformer in the request_pipeline on live"}

      true ->
        :ok
    end
  end

  defp validate_platform_transformers(matcher, spec, env) do
    platform_transformers = Module.concat([Routes, Platforms, spec.platform]).specs(env).request_pipeline
    duplicate_transformers = Enum.uniq(platform_transformers -- Enum.uniq(platform_transformers))
    missing_transformers = (platform_transformers -- spec.request_pipeline) -- [:_routespec_pipeline_placeholder]

    cond do
      duplicate_transformers != [] ->
        {:error,
         "Route #{matcher} contains duplicate platform transformers in the request_pipeline on #{env}: #{inspect(duplicate_transformers)}"}

      missing_transformers != [] ->
        {:error,
         "Route #{matcher} does't have platform transformers #{inspect(missing_transformers)} in the request_pipeline on #{env}"}

      true ->
        :ok
    end
  end

  defp start_route_states(examples) do
    examples
    |> Enum.map(&route_state_id/1)
    |> Enum.uniq()
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.each(&start_route_state/1)

    examples
  end

  defp route_state_id({_matcher, %{using: spec_name, platform: platform}, _example}) when platform in @platforms do
    "#{spec_name}.#{platform}"
  end

  defp route_state_id({_matcher, %{using: _spec_name, platform: _platform}, _example}) do
    nil
  end

  defp start_route_state(route_state_id) do
    start_supervised!(%{
      id: String.to_atom(route_state_id),
      start: {RouteState, :start_link, [route_state_id]}
    })
  end

  defp has_platform_suffix?(%{using: route_spec}) do
    Enum.any?(@platforms, &String.ends_with?(route_spec, ".#{&1}"))
  end

  defp has_platform_key?(%{platform: _}), do: true
  defp has_platform_key?(%{}), do: false

  defp selector_or_platform?(selector_or_platform) do
    String.ends_with?(selector_or_platform, "PlatformSelector") or Enum.member?(@platforms, selector_or_platform)
  end

  defp plug_route(conn) do
    conn.private.plug_route
    |> elem(0)
    |> String.replace("/*_path", "")
    # conn.private.plug_route seems to not show as expected for paths with file extensions,
    # for example:
    #
    #      /news/:id.amp (route) -> /*path/news/:id/.amp (plug_route)
    |> String.replace("/.", ".")
  end
end
