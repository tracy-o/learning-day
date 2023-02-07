# This is a copy of RoutefileTest.
# TODO: look at how we can run tests on all routefiles.

defmodule Routes.SportRoutefileTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper, only: [stub_origins: 0]

  alias BelfrageWeb.Router
  alias Belfrage.{RouteState, RouteSpec}
  alias Routes.Routefiles.Sport.Test, as: Routefile

  @moduletag :routes_test

  @redirect_statuses Application.compile_env(:belfrage, :redirect_statuses)

  @routes Routefile.routes()
  @redirects Routefile.redirects()

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
        # If route spec cannot be found by spec name and platform attributes,
        # then we simply validate the route as we cannot validate the
        # route spec or transformers. This is because the :platform
        # attribute is then expected to be a platform selector, which
        # requires a %Struct to select the platform. Given that we
        # are simply iterating through a list of routes, we do not
        # have access to the %Struct and therefore cannot select the
        # platform and build the route state id.
        {matcher, route = %{using: _, platform: _}} -> validate_route(matcher, route, env)
      end)
    end

    test "route spec for 'live' env is valid" do
      env = "live"

      validate(@routes, fn
        {matcher, route = %{using: _, platform: _, only_on: nil}} -> validate_route(matcher, route, env)
        _ -> :ok
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
      start_route_states()

      @examples
      |> Enum.reject(fn {matcher, _, _} -> matcher == "/*any" end)
      |> validate(fn
        {matcher, %{platform: platform, using: spec_name}, example} ->
          case RouteSpec.get_route_spec({spec_name, platform}) do
            nil ->
              conn = make_call(:get, example)

              if String.starts_with?(conn.assigns.route_spec, spec_name) do
                :ok
              else
                {:error, "Example #{example} for route #{matcher} that uses a platform selector \
                                             is not routed to a route spec that starts with #{spec_name}, \
                                             but to #{conn.assigns.route_spec}"}
              end

            %RouteSpec{route_state_id: route_state_id} ->
              conn = make_call(:get, example)
              plug_route = plug_route(conn)

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

    test "redirect target is not also a redirect" do
      validate(@redirects, fn {from, to, _status} ->
        case Enum.find(@redirects, fn {from, _to, _status} -> from == to end) do
          {matched_from, matched_to, _status} ->
            {:error,
             "Redirect from #{from} to #{to} will be sent to another redirect: from #{matched_from} to #{matched_to}"}

          _ ->
            :ok
        end
      end)
    end

    test "redirect is routed correctly" do
      stub_origins()
      start_route_states()

      @redirects
      |> validate(fn
        {from, to, status} ->
          conn = make_call(:get, from)

          if conn.status == status do
            :ok
          else
            {:error,
             "#{from} in redirect from #{from} to #{to} is not routed correctly - expected status code #{status} but got #{conn.status}"}
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

  defp validate_route(matcher, route = %{using: spec_name, platform: platform}, env) do
    case RouteSpec.get_route_spec({spec_name, platform}, env) do
      nil ->
        validate_required_attrs_in_route(matcher, route, env)

      spec ->
        with :ok <- validate_required_attrs_in_route_spec(matcher, spec, env),
             :ok <- validate_transformers(matcher, spec, env) do
          validate_platform_transformers(matcher, spec, env)
        end
    end
  end

  defp validate_required_attrs_in_route(matcher, route, env) do
    if selector?(route.platform) do
      :ok
    else
      {:error, "Route #{matcher} has a :platform attribute that is not a Platform Selector or Platform \
                         for #{env}.\n Please provide a :platform attribute that is a Platform, or a Platform \
                         Selector that ends with 'PlatformSelector'."}
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
         "Route #{matcher} doesn't have platform transformers #{inspect(missing_transformers)} in the request_pipeline on #{env}"}

      true ->
        :ok
    end
  end

  defp start_route_states() do
    Belfrage.RouteSpecManager.list_specs()
    |> Enum.map(&Map.get(&1, :route_state_id))
    |> Enum.each(&start_route_state/1)
  end

  defp start_route_state(route_state_id) do
    start_supervised!(%{
      id: route_state_id,
      start: {RouteState, :start_link, [route_state_id]}
    })
  end

  defp selector?(selector_or_platform) do
    String.ends_with?(selector_or_platform, "PlatformSelector")
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
