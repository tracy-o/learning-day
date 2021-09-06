defmodule Belfrage.SmokeTest do
  use ExUnit.Case, async: true

  @environments (System.get_env("SMOKE_ENV") || "test,live") |> String.split(",")
  @ignore_specs Application.get_env(:smoke, :ignore_specs)

  @moduletag :smoke_test

  Routes.Routefile.routes()
  |> Enum.filter(fn {_route_matcher, %{using: loop_id, only_on: only_env}} ->
    not (loop_id in @ignore_specs) and only_env != "test"
  end)
  |> Enum.each(fn {route_matcher, matcher_spec} ->
    @matcher_spec Macro.escape(matcher_spec)

    contents =
      quote do
        use Belfrage.SmokeTestCase,
          route_matcher: unquote(route_matcher),
          matcher_spec: unquote(@matcher_spec),
          environments: unquote(@environments)
      end

    unique_module_name = Module.concat(["Belfrage.SmokeTest", matcher_spec.using, UUID.uuid4(:hex)])
    Module.create(unique_module_name, contents, Macro.Env.location(__ENV__))
  end)
end
