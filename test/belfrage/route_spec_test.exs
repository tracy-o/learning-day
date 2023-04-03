defmodule Belfrage.RouteSpecTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.RoutingHelper

  alias Belfrage.{RouteSpec, Envelope}

  describe "get_spec/1" do
    for transformer <- ["Foo", "Bar", "Baz1", "Baz2"],
        do: define_request_transformer(transformer, %Envelope{})

    for transformer <- ["Foo", "Bar", "Baz"],
        do: define_response_transformer(transformer, %Envelope{})

    test "merges route attributes into platform attributes" do
      define_platform("MergePlatform", %{caching_enabled: false, default_language: "foo"})
      define_route("MergeRoute", %{platform: "MergePlatform", default_language: "bar", owner: "baz"})

      spec = RouteSpec.get_route_spec({"MergeRoute", "MergePlatform"})
      assert spec.platform == "MergePlatform"
      assert spec.owner == "baz"
      assert spec.default_language == "bar"
      assert spec.caching_enabled == false
    end

    test "merges allowlists" do
      define_platform("MergeAllowlistPlatform", %{
        query_params_allowlist: ["param1"],
        headers_allowlist: ["header1"],
        cookie_allowlist: ["cookie1"]
      })

      define_route("MergeAllowlistRoute", %{
        platform: "MergeAllowlistPlatform",
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"]
      })

      spec = RouteSpec.get_route_spec({"MergeAllowlistRoute", "MergeAllowlistPlatform"})
      assert spec.query_params_allowlist == ~w(param1 param2)
      assert spec.headers_allowlist == ~w(header1 header2)
      assert spec.cookie_allowlist == ~w(cookie1 cookie2)
    end

    test "does not overwrite wildcard in platform allowlist" do
      define_platform("PlatformWildcardAllowlistPlatform", %{
        query_params_allowlist: "*",
        headers_allowlist: "*",
        cookie_allowlist: "*"
      })

      define_route("PlatformWildcardAllowlistRoute", %{
        platform: "PlatformWildcardAllowlistPlatform",
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"]
      })

      spec = RouteSpec.get_route_spec({"PlatformWildcardAllowlistRoute", "PlatformWildcardAllowlistPlatform"})
      assert spec.query_params_allowlist == "*"
      assert spec.headers_allowlist == "*"
      assert spec.cookie_allowlist == "*"
    end

    test "allows to specify  wildcard in route allowlist" do
      define_platform("RouteWildcardAllowlistPlatform", %{
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"]
      })

      define_route("RouteWildcardAllowlistRoute", %{
        platform: "RouteWildcardAllowlistPlatform",
        query_params_allowlist: "*",
        headers_allowlist: "*",
        cookie_allowlist: "*"
      })

      spec = RouteSpec.get_route_spec({"RouteWildcardAllowlistRoute", "RouteWildcardAllowlistPlatform"})
      assert spec.query_params_allowlist == "*"
      assert spec.headers_allowlist == "*"
      assert spec.cookie_allowlist == "*"
    end

    test "replaces pipeline placeholder with route pipeline" do
      define_platform("PipelinePlaceholderPlatform", %{
        request_pipeline: ["Foo", :_routespec_pipeline_placeholder, "Bar"]
      })

      define_route("NoPipelineRoute", %{platform: "PipelinePlaceholderPlatform"})
      define_route("PipelineRoute", %{platform: "PipelinePlaceholderPlatform", request_pipeline: ["Baz1", "Baz2"]})

      spec = RouteSpec.get_route_spec({"NoPipelineRoute", "PipelinePlaceholderPlatform"})
      assert spec.request_pipeline == ["Foo", "Bar"]

      spec = RouteSpec.get_route_spec({"PipelineRoute", "PipelinePlaceholderPlatform"})
      assert spec.request_pipeline == ["Foo", "Baz1", "Baz2", "Bar"]
    end

    test "overwrites pipeline if platform spec does not have placeholder" do
      define_platform("OverwriteRequestPipelinePlatform", %{request_pipeline: ["Foo"]})

      define_route("OverwriteRequestPipelineRoute", %{
        platform: "OverwriteRequestPipelinePlatform",
        request_pipeline: ["Bar"]
      })

      spec = RouteSpec.get_route_spec({"OverwriteRequestPipelineRoute", "OverwriteRequestPipelinePlatform"})
      assert spec.request_pipeline == ["Bar"]
    end

    test "injects routespec response_pipeline if platform spec has placeholder" do
      define_platform("OverwriteResponsePipelinePlatform", %{
        response_pipeline: ["Foo", :_routespec_pipeline_placeholder, "Baz"]
      })

      define_route("OverwriteResponsePipelineRoute", %{
        platform: "OverwriteResponsePipelinePlatform",
        response_pipeline: ["Bar"]
      })

      spec = RouteSpec.get_route_spec({"OverwriteResponsePipelineRoute", "OverwriteResponsePipelinePlatform"})
      assert spec.response_pipeline == ["Foo", "Bar", "Baz"]
    end

    test "sets personalised_route attribute" do
      define_platform("PersonalisedPlatform", %{})
      define_route("PersonalisedRoute", %{platform: "PersonalisedPlatform", personalisation: "on"})
      define_route("NonPersonalisedRoute", %{platform: "PersonalisedPlatform", personalisation: "off"})

      spec = RouteSpec.get_route_spec({"PersonalisedRoute", "PersonalisedPlatform"})
      assert spec.personalisation == "on"
      assert spec.personalised_route == true

      spec = RouteSpec.get_route_spec({"NonPersonalisedRoute", "PersonalisedPlatform"})
      assert spec.personalisation == "off"
      assert spec.personalised_route == false
    end

    test "invalidates non-existing platform pipeline" do
      define_platform("ResponsePipelinePlatform", %{
        response_pipeline: ["NonExistingTransformer", :_routespec_pipeline_placeholder]
      })

      define_route("ResponsePipelineRoute", %{
        platform: "ResponsePipelinePlatform",
        response_pipeline: ["Bar"]
      })

      err_msg = "Module 'Elixir.Belfrage.ResponseTransformers.NonExistingTransformer' doesn't exist"

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec({"ResponsePipelineRoute", "ResponsePipelinePlatform"})
      end
    end

    test "invalidates non-existing route spec pipeline" do
      define_platform("RequestPipelinePlatform", %{})

      define_route("RequestPipelineRoute", %{
        platform: "RequestPipelinePlatform",
        request_pipeline: ["NonExistingTransformer"]
      })

      err_msg = "Module 'Elixir.Belfrage.RequestTransformers.NonExistingTransformer' doesn't exist"

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec({"RequestPipelineRoute", "RequestPipelinePlatform"})
      end
    end

    test "invalidates non-existing spec" do
      assert_raise RuntimeError, "Module 'Elixir.Routes.Specs.NonExistingRoute' doesn't exist", fn ->
        RouteSpec.get_route_spec({"NonExistingRoute", "NonExistingPlatform"})
      end
    end

    test "invalidates non-existing platform" do
      define_route("Route", %{platform: "NonExistingPlatform"})

      assert_raise RuntimeError, "Module 'Elixir.Routes.Platforms.NonExistingPlatform' doesn't exist", fn ->
        RouteSpec.get_route_spec({"Route", "NonExistingPlatform"})
      end
    end

    test "invalidates not allowed RouteSpec envelope attributes" do
      define_platform("NotAllowedAttrPlatform", %{
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"],
        not_allowed_attr: :blah
      })

      define_route("AllowedAttrRoute", %{platform: "NotAllowedAttrPlatform"})

      err_msg = "Invalid '\"AllowedAttrRoute\"' spec, error: {:badkey, :not_allowed_attr}"

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec({"AllowedAttrRoute", "NotAllowedAttrPlatform"})
      end
    end

    test "invalidates duplicate transformers in pipeline" do
      define_platform("DuplicateTransformersPlatform", %{
        request_pipeline: [:_routespec_pipeline_placeholder, "LambdaOriginAlias", "CircuitBreaker"]
      })

      define_route("DuplicateTransformersRoute", %{
        platform: "DuplicateTransformersPlatform",
        request_pipeline: ["LambdaOriginAlias"]
      })

      err_msg =
        ~s({"DuplicateTransformersRoute", "DuplicateTransformersPlatform"} contains the following duplicated transformers in the request_pipeline : ["LambdaOriginAlias"])

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec({"DuplicateTransformersRoute", "DuplicateTransformersPlatform"})
      end
    end

    test "invalidates when pre_flight_pipeline is required and not present" do
      define_platform("RequiredPreFlightPipelinePlatform", %{
        request_pipeline: ["LambdaOriginAlias", "CircuitBreaker"]
      })

      define_platform("OtherRequiredPreFlightPipelinePlatform", %{
        request_pipeline: ["LambdaOriginAlias", "CircuitBreaker"]
      })

      define_route("RequiredPreFlightPipelineRoute", [
        %{platform: "RequiredPreFlightPipelinePlatform"},
        %{platform: "OtherRequiredPreFlightPipelinePlatform"}
      ])

      assert_raise RuntimeError,
                   "Pre flight pipeline doesn't exist for RequiredPreFlightPipelineRoute, but spec contains multiple Platforms.",
                   fn ->
                     RouteSpec.get_route_spec({"RequiredPreFlightPipelineRoute", "RequiredPreFlightPipelinePlatform"})
                   end
    end
  end
end
