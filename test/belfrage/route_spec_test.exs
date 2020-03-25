defmodule Belfrage.RouteSpecTest do
  use ExUnit.Case
  alias Belfrage.RouteSpec

  describe "merge_specs/2" do
    test "when values are lists, lists are concatenated" do
      platform_specs = %{a: ["one"]}
      route_specs = %{a: ["two"]}

      result = RouteSpec.merge_specs(platform_specs, route_specs)

      assert result == %{a: ["one", "two"]}
    end

    test "when platform allows all query params" do
      platform_specs = %{query_params_allowlist: "*"}
      route_specs = %{query_params_allowlist: ["a-param"]}

      result = RouteSpec.merge_specs(platform_specs, route_specs)

      assert result == %{query_params_allowlist: "*"}
    end

    test "basic behaviour for values, is that route value takes precedence" do
      platform_specs = %{foo: "I want the platform to win"}
      route_specs = %{foo: "I want the route spec to win"}

      result = RouteSpec.merge_specs(platform_specs, route_specs)

      assert result == %{foo: "I want the route spec to win"}
    end
  end
end
