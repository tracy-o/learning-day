defmodule Belfrage.RouteSpecTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.RoutingHelper

  alias Belfrage.RouteSpec

  describe "specs_for/1" do
    test "merges route attributes into platform attributes" do
      define_platform(MergePlatform, %{caching_enabled: false, default_language: "foo"})
      define_route(MergeRoute, %{platform: MergePlatform, default_language: "bar", owner: "baz"})

      spec = RouteSpec.specs_for(MergeRoute)
      assert spec.platform == MergePlatform
      assert spec.owner == "baz"
      assert spec.default_language == "bar"
      assert spec.caching_enabled == false
    end

    test "merges allowlists" do
      define_platform(MergeAllowlistPlatform, %{
        query_params_allowlist: ["param1"],
        headers_allowlist: ["header1"],
        cookie_allowlist: ["cookie1"]
      })

      define_route(MergeAllowlistRoute, %{
        platform: MergeAllowlistPlatform,
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"]
      })

      spec = RouteSpec.specs_for(MergeAllowlistRoute)
      assert spec.query_params_allowlist == ~w(param1 param2)
      assert spec.headers_allowlist == ~w(header1 header2)
      assert spec.cookie_allowlist == ~w(cookie1 cookie2)
    end

    test "does not overwrite wildcard in platform allowlist" do
      define_platform(PlatformWildcardAllowlistPlatform, %{
        query_params_allowlist: "*",
        headers_allowlist: "*",
        cookie_allowlist: "*"
      })

      define_route(PlatformWildcardAllowlistRoute, %{
        platform: PlatformWildcardAllowlistPlatform,
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"]
      })

      spec = RouteSpec.specs_for(PlatformWildcardAllowlistRoute)
      assert spec.query_params_allowlist == "*"
      assert spec.headers_allowlist == "*"
      assert spec.cookie_allowlist == "*"
    end

    test "allows to specify  wildcard in route allowlist" do
      define_platform(RouteWildcardAllowlistPlatform, %{
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"]
      })

      define_route(RouteWildcardAllowlistRoute, %{
        platform: RouteWildcardAllowlistPlatform,
        query_params_allowlist: "*",
        headers_allowlist: "*",
        cookie_allowlist: "*"
      })

      spec = RouteSpec.specs_for(RouteWildcardAllowlistRoute)
      assert spec.query_params_allowlist == "*"
      assert spec.headers_allowlist == "*"
      assert spec.cookie_allowlist == "*"
    end

    test "replaces pipeline placeholder with route pipeline" do
      define_platform(PipelinePlaceholderPlatform, %{pipeline: ["Foo", :_routespec_pipeline_placeholder, "Bar"]})
      define_route(NoPipelineRoute, %{platform: PipelinePlaceholderPlatform})
      define_route(PipelineRoute, %{platform: PipelinePlaceholderPlatform, pipeline: ["Baz1", "Baz2"]})

      spec = RouteSpec.specs_for(NoPipelineRoute)
      assert spec.pipeline == ["Foo", "Bar"]

      spec = RouteSpec.specs_for(PipelineRoute)
      assert spec.pipeline == ["Foo", "Baz1", "Baz2", "Bar"]
    end

    test "overwrites pipeline if platform spec does not have placeholder" do
      define_platform(OverwritePipelinePlatform, %{pipeline: ["Foo"]})
      define_route(OverwritePipelineRoute, %{platform: OverwritePipelinePlatform, pipeline: ["Bar"]})

      spec = RouteSpec.specs_for(OverwritePipelineRoute)
      assert spec.pipeline == ["Bar"]
    end

    test "sets personalised_route attribute" do
      define_platform(PersonalisedPlatform, %{})
      define_route(PersonalisedRoute, %{platform: PersonalisedPlatform, personalisation: "on"})
      define_route(NonPersonalisedRoute, %{platform: PersonalisedPlatform, personalisation: "off"})

      spec = RouteSpec.specs_for(PersonalisedRoute)
      assert spec.personalisation == "on"
      assert spec.personalised_route == true

      spec = RouteSpec.specs_for(NonPersonalisedRoute)
      assert spec.personalisation == "off"
      assert spec.personalised_route == false
    end
  end
end
