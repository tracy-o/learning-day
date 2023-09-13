defmodule Belfrage.SmokeTest do
  use ExUnit.Case, async: true

  # Only live examples testing on live Cosmos production env is supported.
  @environment "live"
  @ignore_specs Application.compile_env(:belfrage, :smoke)[:ignore_specs]

  @moduletag :smoke_test

  Belfrage.RouteSpec.list_examples(@environment)
  |> Enum.filter(fn example -> example.spec not in @ignore_specs end)
  |> Enum.each(fn example ->
    @matcher_spec Macro.escape(example)

    contents =
      quote do
        use Belfrage.SmokeTestCase,
          matcher_spec: unquote(@matcher_spec),
          environment: unquote(@environment)
      end

    unique_module_name = Module.concat(["Belfrage.SmokeTest", example.spec, UUID.uuid4(:hex)])
    Module.create(unique_module_name, contents, Macro.Env.location(__ENV__))
  end)
end
