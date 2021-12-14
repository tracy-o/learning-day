defmodule Routes.RoutefileTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper, only: [stub_origins: 0]

  alias BelfrageWeb.Router
  alias Routes.Routefiles.Test, as: Routefile

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

        validate(@routes, fn {matcher, %{using: loop_id}} ->
          specs = Belfrage.RouteSpec.specs_for(loop_id, env)

          with :ok <- validate_required_attrs_in_route_spec(matcher, specs, env),
               :ok <- validate_transformers(matcher, specs, env),
               :ok <- validate_platform_transformers(matcher, specs, env) do
            :ok
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
      |> Enum.reject(fn {matcher, _, _} -> matcher == "/*any" end)
      |> validate(fn {matcher, %{using: loop_id}, example} ->
        conn = conn(:get, example) |> Router.call([])

        if conn.assigns.route_spec == loop_id do
          :ok
        else
          {:error,
           "Example #{example} for route #{matcher} is not routed to #{loop_id}, but to #{conn.assigns.route_spec}"}
        end
      end)
    end

    test "proxy-pass examples are routed correctly" do
      @examples
      |> Enum.filter(fn {matcher, _, _} -> matcher == "/*any" end)
      |> validate(fn {matcher, _, example} ->
        conn = conn(:get, example)
        conn = Router.call(conn, [])

        if conn.status == 404 && conn.resp_body =~ "404" do
          :ok
        else
          {:error,
           "Example #{example} for route #{matcher} is not routed correctly. Response status: #{conn.status}. Body: #{
             conn.resp_body
           }"}
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

      conn = conn(:get, "/a_route_that_will_not_match")
      conn = Router.call(conn, [])

      assert conn.status == 404
      assert conn.resp_body =~ "404"

      Application.put_env(:belfrage, :production_environment, "test")
    end

    test "when the request is a POST request" do
      conn = conn(:post, "/a_route_that_will_not_match")
      conn = Router.call(conn, [])

      assert conn.status == 405
      assert conn.resp_body =~ "405"
    end
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
      |> Enum.map(&"* #{&1}")
      |> Enum.join("\n")
      |> flunk()
    end
  end

  defp validate_required_attrs_in_route_spec(matcher, spec, env) do
    required_attrs = ~w[platform pipeline circuit_breaker_error_threshold origin]a
    missing_attrs = required_attrs -- Map.keys(spec)

    if missing_attrs == [] do
      :ok
    else
      {:error, "Route #{matcher} doesn't have required attrs #{inspect(missing_attrs)} in route spec for #{env}"}
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
         "Route #{matcher} contains duplicate platform transformers in the pipeline on #{env}: #{
           inspect(duplicate_transformers)
         }"}

      missing_transformers != [] ->
        {:error,
         "Route #{matcher} does't have platform transformers #{inspect(missing_transformers)} in the pipeline on #{env}"}

      true ->
        :ok
    end
  end
end
