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

    test "platform's allow all '*' does not always override routespec value" do
      platform_specs = %{some_key: "*"}
      route_specs = %{some_key: "a-value"}

      result = RouteSpec.merge_specs(platform_specs, route_specs)

      assert result == %{some_key: "a-value"}
    end

    test "when platform allows all headers" do
      platform_specs = %{headers_allowlist: "*"}
      route_specs = %{headers_allowlist: ["a-header"]}

      result = RouteSpec.merge_specs(platform_specs, route_specs)

      assert result == %{headers_allowlist: "*"}
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

  describe "merge_key/3" do
    test "when the key is a :pipeline and the platform_list contains :routespec_placeholder the placeholder is replaced with the routespec_list values" do
      platform_list = ["HttpRedirector", :routespec_placeholder, "CircuitBreaker"]
      routespec_list = ["LambdaOriginAlias", "PlatformKillswitch"]

      result = RouteSpec.merge_key(:pipeline, platform_list, routespec_list)

      assert result == ["HttpRedirector", "LambdaOriginAlias", "PlatformKillswitch", "CircuitBreaker"]
    end

    test "when the key is :pipeline and the platform_list_value does not contain :routespec_placeholder, the routespec values are returned" do
      platform_list = ["HttpRedirector", "CircuitBreaker"]
      routespec_list = ["LambdaOriginAlias", "PlatformKillswitch"]

      result = RouteSpec.merge_key(:pipeline, platform_list, routespec_list)

      assert result == ["LambdaOriginAlias", "PlatformKillswitch"]
    end
  end

  describe "specs_for/1" do
    defmodule Module.concat([Routes, Specs, PersonalisedRouteSpec]) do
      def specs(_) do
        %{
          platform: Webcore,
          personalisation: "on"
        }
      end
    end

    test "adds personalisation attributes" do
      spec = RouteSpec.specs_for(PersonalisedRouteSpec)
      assert spec.personalised_route
    end
  end
end
