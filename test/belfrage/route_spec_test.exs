defmodule Belfrage.RouteSpecTest do
  use ExUnit.Case
  alias Belfrage.RouteSpec

  describe "merge_specs/2" do
    test "when values are lists, lists are concatenated" do
      platform_specs = %{headers_allowlist: ["one", "two"]}
      route_specs = %{headers_allowlist: ["three"]}

      result = RouteSpec.merge_specs(route_specs, platform_specs)

      assert result == %RouteSpec{headers_allowlist: ["one", "two", "three"]}
    end

    test "when platform allows all headers" do
      platform_specs = %{headers_allowlist: "*"}
      route_specs = %{headers_allowlist: ["a-header"]}

      result = RouteSpec.merge_specs(route_specs, platform_specs)

      assert result == %RouteSpec{headers_allowlist: "*"}
    end

    test "when platform allows all query params" do
      platform_specs = %{query_params_allowlist: "*"}
      route_specs = %{query_params_allowlist: ["a-param"]}

      result = RouteSpec.merge_specs(route_specs, platform_specs)

      assert result == %RouteSpec{query_params_allowlist: "*"}
    end

    test "basic behaviour for values, is that route value takes precedence" do
      platform_specs = %{runbook: "I want the platform to win"}
      route_specs = %{runbook: "I want the route spec to win"}

      result = RouteSpec.merge_specs(route_specs, platform_specs)

      assert result == %RouteSpec{runbook: "I want the route spec to win"}
    end

    test "platforms keys are returned if the same response key is not set" do
      platform_specs = %{pipeline: ["HttpRedirector", "CircuitBreaker"]}
      route_specs = %{owner: "owner@bbc.co.uk"}

      result = RouteSpec.merge_specs(route_specs, platform_specs)

      assert result == %Belfrage.RouteSpec{owner: "owner@bbc.co.uk", pipeline: ["HttpRedirector", "CircuitBreaker"]}
    end
  end

  describe "merge_key/3" do
    test "when the key is a :pipeline and the platform_list contains :routespec_placeholder the placeholder is replaced with the routespec_list values" do
      platform_list = ["HttpRedirector", :_routespec_pipeline_placeholder, "CircuitBreaker"]
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

    test "when the key is a :response_pipeline and the platform_list contains :_routespec_pipeline_placeholder the placeholder is replaced with the routespec_list values" do
      platform_list = ["HttpRedirector", :_routespec_pipeline_placeholder, "CircuitBreaker"]
      routespec_list = ["LambdaOriginAlias", "PlatformKillswitch"]

      result = RouteSpec.merge_key(:resp_pipeline, platform_list, routespec_list)

      assert result == ["HttpRedirector", "LambdaOriginAlias", "PlatformKillswitch", "CircuitBreaker"]
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

    defmodule Module.concat([Routes, Specs, PlaceholderRouteSpec]) do
      def specs(_) do
        %{
          platform: MozartNews,
          pipeline: ["SomeRedirectLogic"],
          resp_pipeline: ["SomeRedirectLogic"]
        }
      end
    end

    test ":_routespec_pipeline_placeholder is removed if :pipeline and :response_pipeline keys are present in routespec" do
      spec = RouteSpec.specs_for(PlaceholderRouteSpec)
      assert ":_routespec_pipeline_placeholder" not in spec.pipeline
      assert ":_routespec_pipeline_placeholder" not in spec.resp_pipeline
    end

    defmodule Module.concat([Routes, Specs, NonPlaceholderRouteSpec]) do
      def specs(_) do
        %{
          platform: MozartNews
        }
      end
    end

    test ":_routespec_pipeline_placeholder is removed if :pipeline and :response_pipeline keys aren't present in routespec" do
      spec = RouteSpec.specs_for(NonPlaceholderRouteSpec)
      assert ":_routespec_pipeline_placeholder" not in spec.pipeline
      assert ":_routespec_pipeline_placeholder" not in spec.resp_pipeline
    end
  end
end
