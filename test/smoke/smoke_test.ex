defmodule Belfrage.SmokeTest do
  use ExUnit.Case, async: true
  alias Test.Support.Helper
  alias Belfrage.RouteSpec

  @targets Application.get_env(:smoke, :test) |> Map.keys()
  @environments System.get_env("SMOKE_ENV", "test,live") |> String.split(",")

  @moduletag :smoke_test

  # TODO filter out app config `:ignore_specs` list
  Routes.Routefile.routes_with_env()
  |> Enum.sort_by(fn {_route_matcher, %{using: loop_id}} -> loop_id end)
  |> Enum.chunk_by(fn {_route_matcher, %{using: loop_id}} -> loop_id end)
  |> Enum.each(fn route_matcher_specs ->
    for {{route_matcher, matcher_spec}, index} <- Enum.with_index(route_matcher_specs) do
      @matcher_spec Macro.escape(matcher_spec)

      contents =
        quote do
          use Belfrage.SmokeTestCase,
            route_matcher: unquote(route_matcher),
            matcher_spec: unquote(@matcher_spec),
            targets: unquote(@targets),
            environments: unquote(@environments)
        end

      module = Module.concat(["Belfrage.SmokeTest", matcher_spec.using, Integer.to_string(index)])
      Module.create(module, contents, Macro.Env.location(__ENV__))
    end
  end)
end
