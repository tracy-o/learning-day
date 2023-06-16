defmodule Belfrage.SmokeTest do
  use ExUnit.Case, async: true

  @environments (System.get_env("SMOKE_ENV") || "test,live") |> String.split(",")
  @ignore_specs Application.compile_env(:belfrage, :smoke)[:ignore_specs]

  # Only live examples testing is supported. Test examples are not tested
  @prod_env "live"

  @moduletag :smoke_test

  Belfrage.RouteSpec.list_examples(@prod_env)
  |> Enum.filter(fn example -> example.spec not in @ignore_specs end)
  |> Enum.each(fn example ->
    @matcher_spec Macro.escape(example)

    contents =
      quote do
        use Belfrage.SmokeTestCase,
          matcher_spec: unquote(@matcher_spec),
          environments: unquote(@environments)
      end

    unique_module_name = Module.concat(["Belfrage.SmokeTest", example.spec, UUID.uuid4(:hex)])
    Module.create(unique_module_name, contents, Macro.Env.location(__ENV__))
  end)
end
