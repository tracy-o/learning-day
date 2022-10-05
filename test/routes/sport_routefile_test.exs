# This is a copy of RoutefileTest.
# TODO: look at how we can run tests on all routefiles.

defmodule Routes.SportRoutefileTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper, only: [stub_origins: 0]

  alias BelfrageWeb.Router
  alias Belfrage.{RouteState, Clients}
  alias Routes.Routefiles.Sport.Test, as: Routefile

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)

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

    for env <- ~w(test live) do
      test "route spec for #{env} is valid" do
        env = unquote(env)

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

          {matcher, route = %{using: route_state_id, platform: platform}} ->
            route_state_id = "#{platform}.#{route_state_id}"
            route_spec_attrs = Belfrage.RouteSpec.get_route_spec_attrs(route_state_id, env)
            specs = Belfrage.RouteSpec.specs_for(route_state_id, env)

            with :ok <- validate_required_attrs_in_route(matcher, route, route_spec_attrs, env),
                 :ok <- validate_required_attrs_in_route_spec(matcher, specs, env),
                 :ok <- validate_transformers(matcher, specs, env) do
              validate_platform_transformers(matcher, specs, env)
            end

          {matcher, route = %{using: route_state_id}} ->
            route_spec_attrs = Belfrage.RouteSpec.get_route_spec_attrs(route_state_id, env)
            specs = Belfrage.RouteSpec.specs_for(route_state_id, env)
            route = maybe_update_route_state_id(route)

            with :ok <- validate_required_attrs_in_route(matcher, route, route_spec_attrs, env),
                 :ok <- validate_required_attrs_in_route_spec(matcher, specs, env),
                 :ok <- validate_transformers(matcher, specs, env) do
              validate_platform_transformers(matcher, specs, env)
            end
        end)
      end
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
        {matcher, %{platform: platform, using: route_state_id}, example} when platform in @platforms ->
          conn = make_call(:get, example)

          if conn.assigns.route_spec == "#{platform}.#{route_state_id}" do
            :ok
          else
            {:error,
             "Example #{example} for route #{matcher} is not routed to #{route_state_id}, but to #{conn.assigns.route_spec}"}
          end

        {matcher, %{platform: platform, using: route_state_id}, example} ->
          mock_selector_endpoint(platform, example)
          conn = make_call(:get, example)

          if String.ends_with?(conn.assigns.route_spec, route_state_id) do
            :ok
          else
            {:error,
             "Example #{example} for route #{matcher} with a selector is not routed to a route spec ending in #{route_state_id}, but to #{conn.assigns.route_spec}"}
          end

        {matcher, %{using: route_state_id}, example} ->
          conn = make_call(:get, example)

          if conn.assigns.route_spec == route_state_id do
            :ok
          else
            {:error,
             "Example #{example} for route #{matcher} is not routed to #{route_state_id}, but to #{conn.assigns.route_spec}"}
          end
      end)
    end

    test "proxy-pass examples are routed correctly" do
      start_supervised!({RouteState, "ProxyPass"})

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

  defp validate_required_attrs_in_route(matcher, route, spec, env) do
    cond do
      # If the name of the RouteSpec in the :using attribute has a platform
      # suffix, then we return an error tuple.
      #
      # This is because the :platform key in the route should be used
      # to later determine the platform suffix of the RouteSpec id.
      has_platform_suffix?(route) ->
        {:error,
         "Route #{matcher} has a route spec that is suffixed with a :platform for #{env}.\n Please remove the suffix and ensure that there is a :platform attribute in the route.."}

      # If the route and the RouteSpec both have a :platform key
      # then we return an error tuple, as we only expect
      # a :platform key in either or the other.
      #
      # This is because if present, the :platform key in the route
      # is used to determine the :platform in the RouteSpec,
      # and is not supposed to override it.
      has_platform_key?(route) and has_platform_key?(spec) ->
        {:error,
         "Route #{matcher} has a :platform attribute when :platform is specified in route spec for #{env}.\n Please remove the :platform attribute in the route spec if it must be specified in the route.\n Otherwise remove the :platform attribute in the route."}

      # If the platform attribute has a :platform key
      # that is neither a Platform nor a Selector ending
      # in "Selector", then we raise a error. This is to
      # enforce the said convention.
      has_platform_key?(route) and not selector_or_platform?(route.platform) ->
        {:error,
         ~s(Route #{matcher} has a :platform attribute that is not a Selector or Platform for #{env}.\n Please provide a :platform attribute that is a Platform, or a Selector that ends with "Selector".)}

      true ->
        :ok
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
         "Route #{matcher} has a route spec that is suffixed with a :platform for #{env}.\n Please remove the suffix and ensure that there is a :platform attribute in the route.."}

      # If the platform attribute has a :platform key
      # that is neither a Platform nor a Selector ending
      # in "Selector", then we raise a error. This is to
      # enforce the said convention.
      has_platform_key?(route) and not selector_or_platform?(route.platform) ->
        {:error,
         ~s(Route #{matcher} has a :platform attribute that is not a Selector or Platform for #{env}.\n Please provide a :platform attribute that is a Platform, or a Selector that ends with "Selector".)}

      true ->
        :ok
    end
  end

  defp validate_required_attrs_in_route_spec(matcher, spec, env) do
    required_attrs = ~w[platform pipeline circuit_breaker_error_threshold origin]a
    missing_attrs = required_attrs -- Map.keys(spec)

    if missing_attrs != [] do
      {:error, "Route #{matcher} doesn't have required attrs #{inspect(missing_attrs)} in route spec for #{env}"}
    else
      :ok
    end
  end

  defp validate_transformers(matcher, spec, env) do
    invalid_transformers =
      Enum.filter(spec.pipeline, fn transformer ->
        match?({:error, _}, Code.ensure_compiled(Module.concat([Belfrage, Transformers, transformer])))
      end)

    duplicate_transformers = Enum.uniq(spec.pipeline -- Enum.uniq(spec.pipeline))

    cond do
      invalid_transformers != [] ->
        {:error,
         "Route #{matcher} contains invalid transformers in the pipeline on #{env}: #{inspect(invalid_transformers)}"}

      duplicate_transformers != [] ->
        {:error,
         "Route #{matcher} contains duplicate transformers in the pipeline on #{env}: #{inspect(duplicate_transformers)}"}

      env == "live" && "DevelopmentRequests" in spec.pipeline ->
        {:error, "Route #{matcher} contains DevelopmentRequests transformer in the pipeline on live"}

      true ->
        :ok
    end
  end

  defp validate_platform_transformers(matcher, spec, env) do
    platform_transformers = Module.concat([Routes, Platforms, spec.platform]).specs(env).pipeline
    duplicate_transformers = Enum.uniq(platform_transformers -- Enum.uniq(platform_transformers))
    missing_transformers = (platform_transformers -- spec.pipeline) -- [:_routespec_pipeline_placeholder]

    cond do
      duplicate_transformers != [] ->
        {:error,
         "Route #{matcher} contains duplicate platform transformers in the pipeline on #{env}: #{inspect(duplicate_transformers)}"}

      missing_transformers != [] ->
        {:error,
         "Route #{matcher} does't have platform transformers #{inspect(missing_transformers)} in the pipeline on #{env}"}

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

  defp route_state_id({_matcher, %{using: route_state_id, platform: platform}, _example}) when platform in @platforms do
    "#{platform}.#{route_state_id}"
  end

  defp route_state_id({_matcher, %{using: _route_state_id, platform: _platform}, _example}) do
    nil
  end

  defp route_state_id({_matcher, %{using: route_state_id}, _example}) do
    route_state_id
  end

  defp route_state_id(route = %{}) do
    case route do
      %{platform: platform, using: route_state_id} ->
        "#{platform}.#{route_state_id}"

      %{using: route_state_id} ->
        route_state_id
    end
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

  defp maybe_update_route_state_id(route = %{}) do
    case route do
      %{platform: platform, using: route_state_id} ->
        Map.put(route, :using, "#{platform}.#{route_state_id}")

      _route ->
        route
    end
  end

  def mock_selector_endpoint(platform, path) do
    case platform do
      "AssetTypePlatformSelector" ->
        query_params = Plug.Conn.Query.encode(%{path: path})
        url = "#{@fabl_endpoint}/module/ares-data?#{query_params}"

        Clients.HTTPMock
        |> expect(
          :execute,
          2,
          fn
            %Clients.HTTP.Request{method: :get, url: ^url}, :Fabl ->
              {:ok,
               %Clients.HTTP.Response{status_code: 200, body: "{\"section\": \"business\", \"assetType\": \"ABC\"}"}}

            _request, _platform ->
              {:ok, Belfrage.Clients.HTTP.Response.new(%{status_code: 200, headers: %{}, body: "OK"})}
          end
        )

      _platform ->
        nil
    end
  end
end
