defmodule Routes.RoutefileTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper, only: [stub_origins: 0]

  alias BelfrageWeb.Router
  alias Belfrage.{RouteState, RouteSpec, RouteSpecManager}
  alias Routes.Routefiles.Main.Test, as: Routefile

  @moduletag :routes_test

  @pipeline_placeholder :_routespec_pipeline_placeholder

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
        {matcher, route = %{using: _}} -> validate_route(matcher, route, env)
      end)
    end

    test "route spec for 'live' env is valid" do
      env = "live"
      update_specs(env)

      validate(@routes, fn
        {matcher, route = %{using: _, only_on: nil}} -> validate_route(matcher, route, env)
        _ -> :ok
      end)

      update_specs("test")
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
      start_route_states()

      @examples
      |> Enum.reject(fn {matcher, _, _} -> matcher == "/*any" end)
      |> validate(fn {matcher, route, example} -> validate_example({matcher, route, example}) end)
    end

    test "no routes with the same path exist" do
      stub_origins()
      start_route_states()

      @routes
      |> Enum.reject(fn {matcher, _} -> matcher == "/*any" end)
      |> same_path_messages()
      |> case do
        "" ->
          :ok

        msg ->
          flunk(msg)
      end
    end

    test "proxy-pass examples are routed correctly" do
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
      |> List.flatten()
      |> Enum.map_join("\n", &"* #{&1}")
      |> flunk()
    end
  end

  defp validate_route(matcher, %{using: spec_name}, env) do
    case RouteSpecManager.get_spec(spec_name) do
      nil ->
        {:error, "The route with the path #{matcher} does not exist in the RouteSpec: #{spec_name} for #{env}."}

      %{specs: specs, preflight_pipeline: preflight_pipeline} ->
        with :ok <- validate_transformers(matcher, preflight_pipeline, PreflightTransformers, env) do
          validate_specs(matcher, specs, env)
        end
    end
  end

  defp validate_specs(matcher, specs, env) do
    results = for spec <- specs, do: validate_spec(matcher, spec, env)

    if Enum.all?(results, fn x -> x == :ok end) do
      :ok
    else
      {:error, results}
    end
  end

  defp validate_spec(matcher, spec, env) do
    with :ok <- validate_required_attrs_in_route_spec(matcher, spec, env),
         :ok <- validate_transformers(matcher, spec.request_pipeline, RequestTransformers, env),
         :ok <- validate_transformers(matcher, spec.response_pipeline, ResponseTransformers, env),
         :ok <- validate_platform_transformers(matcher, spec.platform, spec.request_pipeline, :request, env) do
      validate_platform_transformers(matcher, spec.platform, spec.response_pipeline, :response, env)
    end
  end

  defp validate_example({matcher, %{using: spec_name}, example}) do
    case RouteSpecManager.get_spec(spec_name) do
      nil ->
        {:error, "The route with the path #{matcher} does not exist in the RouteSpec: #{spec_name}."}

      %{name: ^spec_name} ->
        conn = make_call(:get, example)
        plug_route = plug_route(conn)

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
  end

  defp validate_required_attrs_in_route_spec(matcher, spec, env) do
    required_attrs = ~w[platform request_pipeline circuit_breaker_error_threshold origin]a
    missing_attrs = required_attrs -- Map.keys(spec)

    if missing_attrs != [] do
      "Route #{matcher} doesn't have required attrs #{inspect(missing_attrs)} in route spec for #{env}"
    else
      :ok
    end
  end

  defp validate_transformers(matcher, pipeline, pipeline_path, env) do
    invalid_transformers =
      Enum.filter(pipeline, fn transformer ->
        match?({:error, _}, Code.ensure_compiled(Module.concat([Belfrage, pipeline_path, transformer])))
      end)

    duplicate_transformers = Enum.uniq(pipeline -- Enum.uniq(pipeline))

    cond do
      invalid_transformers != [] ->
        "Route #{matcher} contains invalid transformers in the #{pipeline_path} on #{env}: #{inspect(invalid_transformers)}"

      duplicate_transformers != [] ->
        "Route #{matcher} contains duplicate transformers in the #{pipeline_path} on #{env}: #{inspect(duplicate_transformers)}"

      env == "live" && "DevelopmentRequests" in pipeline ->
        "Route #{matcher} contains DevelopmentRequests transformer in the #{pipeline_path} on live"

      true ->
        :ok
    end
  end

  defp validate_platform_transformers(matcher, platform, pipeline, type = :request, env) do
    platform_transformers = Module.concat([Routes, Platforms, platform]).specification(env).request_pipeline
    do_validate_platform_transformers(matcher, platform_transformers, pipeline, type, env)
  end

  defp validate_platform_transformers(matcher, platform, pipeline, type = :response, env) do
    platform_transformers = Module.concat([Routes, Platforms, platform]).specification(env).response_pipeline
    do_validate_platform_transformers(matcher, platform_transformers, pipeline, type, env)
  end

  defp do_validate_platform_transformers(matcher, platform_transformers, spec_transformers, type, env) do
    duplicate_transformers = Enum.uniq(platform_transformers -- Enum.uniq(platform_transformers))

    missing_transformers =
      if Enum.member?(platform_transformers, @pipeline_placeholder) do
        (platform_transformers -- spec_transformers) -- [@pipeline_placeholder]
      else
        []
      end

    cond do
      duplicate_transformers != [] ->
        "Route #{matcher} contains duplicate platform transformers in the #{type}_pipeline on #{env}: #{inspect(duplicate_transformers)}"

      missing_transformers != [] ->
        "Route #{matcher} doesn't have platform transformers #{inspect(missing_transformers)} in the #{type}_pipeline on #{env}"

      true ->
        :ok
    end
  end

  defp start_route_states() do
    stub_origins()
    Belfrage.RouteSpecManager.list_specs() |> Enum.map(fn spec -> Enum.each(spec.specs, &start_route_state/1) end)
  end

  defp start_route_state(%RouteSpec{
         name: name,
         platform: platform,
         origin: origin,
         circuit_breaker_error_threshold: threshold
       }) do
    route_state_id = {name, platform}

    route_state_args = %{
      origin: origin,
      circuit_breaker_error_threshold: threshold
    }

    case start_supervised(%{
           id: route_state_id,
           start: {RouteState, :start_link, [{route_state_id, route_state_args}]}
         }) do
      {:ok, _pid} -> :ok
      {:error, {{:already_started, _pid}, _child_spec}} -> :ok
      error -> raise "failed to start #{inspect(route_state_id)} child, reason: #{inspect(error)}"
    end
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

  # Takes a list of routes and returns a string
  # detailing groups of routes that share the same path.
  defp same_path_messages(routes) do
    routes
    |> Enum.group_by(fn {matcher, _attributes} -> matcher end)
    |> Enum.reduce([], fn {_k, v}, acc ->
      if Enum.count(v) > 1 do
        [same_path_message(v) | acc]
      else
        acc
      end
    end)
    |> Enum.join("\n")
  end

  defp serialize_routes(routes) do
    Enum.map_join(routes, "\n", &serialize_route/1)
  end

  defp serialize_route(route, prefix \\ " * ")

  defp serialize_route({matcher, %{using: id, only_on: env}}, prefix)
       when env in ["live", "test"] do
    prefix <> "handle #{matcher}, using: #{id}, only_on: #{env} ..."
  end

  defp serialize_route({matcher, %{using: id}}, prefix) do
    prefix <> "handle #{matcher}, using: #{id} ..."
  end

  defp same_path_message(same_path_routes) do
    "The following routes contain the same path - only one route should exist for a given path." <>
      "\n" <> serialize_routes(same_path_routes) <> "\n"
  end

  defp update_specs(env) do
    Application.put_env(:belfrage, :production_environment, env)
    RouteSpecManager.update_specs()
  end
end
