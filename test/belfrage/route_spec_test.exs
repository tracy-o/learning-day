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

  describe "interpolate_personalisation/1" do
    setup do
      %{
        route_spec: %{
          owner: "An owner",
          runbook: "A run book",
          platform: Webcore,
          pipeline: ["a", "really", "long", "pipeline"]
        }
      }
    end

    test "a routespec with personalisation: 'on' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "on")

      assert RouteSpec.interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "on",
               cookie_allowlist: ["ckns_atkn", "ckns_id"],
               headers_allowlist: ["x-id-oidc-signedin"]
             }
    end

    test "a routespec with personalisation: 'off' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "off")

      assert RouteSpec.interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "off"
             }
    end

    test "a routespec with personalisation: 'test_only' is interpolated correctly when on 'test'", %{
      route_spec: route_spec
    } do
      route_spec = Map.put(route_spec, :personalisation, "test_only")

      assert RouteSpec.interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "test_only",
               cookie_allowlist: ["ckns_atkn", "ckns_id"],
               headers_allowlist: ["x-id-oidc-signedin"]
             }
    end

    test "a routespec with personalisation: 'test_only' is interpolated correctly when on 'live'", %{
      route_spec: route_spec
    } do
      route_spec = Map.put(route_spec, :personalisation, "test_only")

      Application.put_env(:belfrage, :production_environment, "live")

      assert RouteSpec.interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "test_only"
             }
    end
  end
end
