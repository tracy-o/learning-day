defmodule Belfrage.RouteSpecTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.RoutingHelper

  alias Belfrage.{RouteSpec, Envelope}

  describe "get_route_spec/1" do
    for transformer <- ["Foo", "Bar", "Baz1", "Baz2"],
        do: define_request_transformer(transformer, %Envelope{})

    for transformer <- ["Foo", "Bar", "Baz"],
        do: define_response_transformer(transformer, %Envelope{})

    test "merges route attributes into platform attributes" do
      define_platform("MergePlatform", %{caching_enabled: false, default_language: "foo"})
      define_route("MergeRoute", %{specs: %{platform: "MergePlatform", default_language: "bar", owner: "baz"}})

      %{specs: [spec]} = RouteSpec.get_route_spec("MergeRoute")
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
        specs: %{
          platform: "MergeAllowlistPlatform",
          query_params_allowlist: ["param2"],
          headers_allowlist: ["header2"],
          cookie_allowlist: ["cookie2"]
        }
      })

      %{specs: [spec]} = RouteSpec.get_route_spec("MergeAllowlistRoute")
      assert spec.platform == "MergeAllowlistPlatform"
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
        specs: %{
          platform: "PlatformWildcardAllowlistPlatform",
          query_params_allowlist: ["param2"],
          headers_allowlist: ["header2"],
          cookie_allowlist: ["cookie2"]
        }
      })

      %{specs: [spec]} = RouteSpec.get_route_spec("PlatformWildcardAllowlistRoute")
      assert spec.platform == "PlatformWildcardAllowlistPlatform"
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
        specs: %{
          platform: "RouteWildcardAllowlistPlatform",
          query_params_allowlist: "*",
          headers_allowlist: "*",
          cookie_allowlist: "*"
        }
      })

      %{specs: [spec]} = RouteSpec.get_route_spec("RouteWildcardAllowlistRoute")
      assert spec.platform == "RouteWildcardAllowlistPlatform"
      assert spec.query_params_allowlist == "*"
      assert spec.headers_allowlist == "*"
      assert spec.cookie_allowlist == "*"
    end

    test "replaces pipeline placeholder with route pipeline" do
      define_platform("PipelinePlaceholderPlatform", %{
        request_pipeline: ["Foo", :_routespec_pipeline_placeholder, "Bar"]
      })

      define_route("NoPipelineRoute", %{specs: %{platform: "PipelinePlaceholderPlatform"}})

      define_route("PipelineRoute", %{
        specs: %{platform: "PipelinePlaceholderPlatform", request_pipeline: ["Baz1", "Baz2"]}
      })

      %{specs: [spec]} = RouteSpec.get_route_spec("NoPipelineRoute")
      assert spec.platform == "PipelinePlaceholderPlatform"
      assert spec.request_pipeline == ["Foo", "Bar"]

      %{specs: [spec]} = RouteSpec.get_route_spec("PipelineRoute")
      assert spec.platform == "PipelinePlaceholderPlatform"
      assert spec.request_pipeline == ["Foo", "Baz1", "Baz2", "Bar"]
    end

    test "overwrites pipeline if platform spec does not have placeholder" do
      define_platform("OverwriteRequestPipelinePlatform", %{request_pipeline: ["Foo"]})

      define_route("OverwriteRequestPipelineRoute", %{
        specs: %{
          platform: "OverwriteRequestPipelinePlatform",
          request_pipeline: ["Bar"]
        }
      })

      %{specs: [spec]} = RouteSpec.get_route_spec("OverwriteRequestPipelineRoute")
      assert spec.platform == "OverwriteRequestPipelinePlatform"
      assert spec.request_pipeline == ["Bar"]
    end

    test "injects routespec response_pipeline if platform spec has placeholder" do
      define_platform("OverwriteResponsePipelinePlatform", %{
        response_pipeline: ["Foo", :_routespec_pipeline_placeholder, "Baz"]
      })

      define_route("OverwriteResponsePipelineRoute", %{
        specs: %{
          platform: "OverwriteResponsePipelinePlatform",
          response_pipeline: ["Bar"]
        }
      })

      %{specs: [spec]} = RouteSpec.get_route_spec("OverwriteResponsePipelineRoute")
      assert spec.platform == "OverwriteResponsePipelinePlatform"
      assert spec.response_pipeline == ["Foo", "Bar", "Baz"]
    end

    test "sets personalised_route attribute" do
      define_platform("PersonalisedPlatform", %{})
      define_route("PersonalisedRoute", %{specs: %{platform: "PersonalisedPlatform", personalisation: "on"}})
      define_route("NonPersonalisedRoute", %{specs: %{platform: "PersonalisedPlatform", personalisation: "off"}})

      %{specs: [spec]} = RouteSpec.get_route_spec("PersonalisedRoute")
      assert spec.platform == "PersonalisedPlatform"
      assert spec.personalisation == "on"
      assert spec.personalised_route == true

      %{specs: [spec]} = RouteSpec.get_route_spec("NonPersonalisedRoute")
      assert spec.platform == "PersonalisedPlatform"
      assert spec.personalisation == "off"
      assert spec.personalised_route == false
    end

    test "returns multiple specs" do
      define_platform("MultiSpecPlatform1", %{})
      define_platform("MultiSpecPlatform2", %{})

      define_route(
        "MultiSpecRoute",
        %{
          preflight_pipeline: ["TestPreflightTransformer"],
          specs: [%{platform: "MultiSpecPlatform1"}, %{platform: "MultiSpecPlatform2"}]
        }
      )

      %{specs: [spec_1, spec_2]} = RouteSpec.get_route_spec("MultiSpecRoute")
      assert spec_1.platform == "MultiSpecPlatform1"
      assert spec_2.platform == "MultiSpecPlatform2"
    end

    test "invalidates non-existing platform pipeline" do
      define_platform("ResponsePipelinePlatform", %{
        response_pipeline: ["NonExistingTransformer", :_routespec_pipeline_placeholder]
      })

      define_route("ResponsePipelineRoute", %{
        specs: %{
          platform: "ResponsePipelinePlatform",
          response_pipeline: ["Bar"]
        }
      })

      err_msg = "Module 'Elixir.Belfrage.ResponseTransformers.NonExistingTransformer' doesn't exist"

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec("ResponsePipelineRoute")
      end
    end

    test "invalidates non-existing route spec pipeline" do
      define_platform("RequestPipelinePlatform", %{})

      define_route("RequestPipelineRoute", %{
        specs: %{
          platform: "RequestPipelinePlatform",
          request_pipeline: ["NonExistingTransformer"]
        }
      })

      err_msg = "Module 'Elixir.Belfrage.RequestTransformers.NonExistingTransformer' doesn't exist"

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec("RequestPipelineRoute")
      end
    end

    test "invalidates non-existing spec" do
      assert_raise RuntimeError, "Module 'Elixir.Routes.Specs.NonExistingRoute' doesn't exist", fn ->
        RouteSpec.get_route_spec("NonExistingRoute")
      end
    end

    test "invalidates non-existing platform" do
      define_route("Route", %{specs: %{platform: "NonExistingPlatform"}})

      assert_raise RuntimeError, "Module 'Elixir.Routes.Platforms.NonExistingPlatform' doesn't exist", fn ->
        RouteSpec.get_route_spec("Route")
      end
    end

    test "invalidates not allowed RouteSpec envelope attributes" do
      define_platform("NotAllowedAttrPlatform", %{
        query_params_allowlist: ["param2"],
        headers_allowlist: ["header2"],
        cookie_allowlist: ["cookie2"],
        not_allowed_attr: :blah
      })

      define_route("AllowedAttrRoute", %{specs: %{platform: "NotAllowedAttrPlatform"}})

      err_msg = "Invalid '\"AllowedAttrRoute\"' spec, error: {:badkey, :not_allowed_attr}"

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec("AllowedAttrRoute")
      end
    end

    test "invalidates duplicate request transformers in pipeline" do
      define_platform("DuplicateTransformersPlatform", %{
        request_pipeline: [:_routespec_pipeline_placeholder, "LambdaOriginAlias", "CircuitBreaker"]
      })

      define_route("DuplicateTransformersRoute", %{
        specs: %{
          platform: "DuplicateTransformersPlatform",
          request_pipeline: ["LambdaOriginAlias"]
        }
      })

      err_msg =
        ~s(request_transformers are not unique, spec: 'DuplicateTransformersRoute', duplicates: [\"LambdaOriginAlias\"])

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec("DuplicateTransformersRoute")
      end
    end

    test "invalidates duplicate preflight transformers in pipeline" do
      define_platform("DuplicatePreflightTransformersPlatform", %{})

      define_route(
        "DuplicatePreflightTransformersRoute",
        %{
          preflight_pipeline: ["TestPreflightTransformer", "TestPreflightTransformer"],
          specs: %{platform: "DuplicatePreflightTransformersPlatform"}
        }
      )

      err_msg =
        ~s(preflight_transformers are not unique, spec: 'DuplicatePreflightTransformersRoute', duplicates: [\"TestPreflightTransformer\"])

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec("DuplicatePreflightTransformersRoute")
      end
    end

    test "invalidates duplicate platforms in multiple specs" do
      define_platform("DuplicatePlatform", %{})

      define_route(
        "DuplicatePlatformRoute",
        %{
          preflight_pipeline: ["TestPreflightTransformer"],
          specs: [%{platform: "DuplicatePlatform"}, %{platform: "DuplicatePlatform"}]
        }
      )

      err_msg =
        ~s(platforms in specs are not unique, spec: 'DuplicatePlatformRoute', duplicates: [\"DuplicatePlatform\"])

      assert_raise RuntimeError, err_msg, fn ->
        RouteSpec.get_route_spec("DuplicatePlatformRoute")
      end
    end

    test "invalidates when preflight_pipeline is required and not present" do
      define_platform("RequiredPreflightPipelinePlatform", %{
        request_pipeline: ["LambdaOriginAlias", "CircuitBreaker"]
      })

      define_platform("OtherRequiredPreflightPipelinePlatform", %{
        request_pipeline: ["LambdaOriginAlias", "CircuitBreaker"]
      })

      define_route(
        "RequiredPreflightPipelineRoute",
        %{
          specs: [
            %{platform: "RequiredPreflightPipelinePlatform"},
            %{platform: "OtherRequiredPreflightPipelinePlatform"}
          ]
        }
      )

      assert_raise RuntimeError,
                   "Pre flight pipeline doesn't exist for RequiredPreflightPipelineRoute, but spec contains multiple Platforms.",
                   fn ->
                     RouteSpec.get_route_spec("RequiredPreflightPipelineRoute")
                   end
    end
  end
end
