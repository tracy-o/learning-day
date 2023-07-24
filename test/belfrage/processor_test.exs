defmodule Belfrage.ProcessorTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog
  import Belfrage.Test.CachingHelper
  import Mock

  alias Belfrage.{Processor, Pipeline, Envelope, RequestHash}
  alias Belfrage.Envelope.{Request, Response, Private}
  alias Belfrage.Metrics.LatencyMonitor

  @spec_name "SportVideos"
  @platform_name "Webcore"
  @route_state_id {@spec_name, @platform_name}

  defmodule Module.concat([Routes, Specs, SomePersonalisedRouteState]) do
    def specification do
      %{
        specs: %{
          platform: "Webcore",
          personalisation: "test_only",
          response_pipeline: ["CacheDirective"]
        }
      }
    end
  end

  describe "Processor.get_route_spec/1" do
    @webcore_request_pipeline [
      "SessionState",
      "PersonalisationGuardian",
      "LambdaOriginAlias",
      "Language",
      "PlatformKillSwitch",
      "IsCommercial",
      "CircuitBreaker",
      "DevelopmentRequests"
    ]
    @webcore_response_pipeline [
      "CacheDirective",
      "ClassicAppCacheControl",
      "ResponseHeaderGuardian",
      "CustomRssErrorResponse",
      "PreCacheCompression"
    ]

    test "with multiple specs and preflight pipeline that updates platform" do
      spec_name = "SomeRouteStateWithMultipleSpecs"
      envelope = %Envelope{private: %Private{spec: spec_name}}

      assert %Envelope{
               private: %Private{
                 route_state_id: {^spec_name, @platform_name},
                 spec: ^spec_name,
                 platform: @platform_name,
                 partition: nil,
                 request_pipeline: @webcore_request_pipeline,
                 response_pipeline: @webcore_response_pipeline,
                 owner: "Some guy",
                 runbook: "Some runbook"
               }
             } = Processor.get_route_spec(envelope)
    end

    test "with single spec and preflight pipeline that updates partition only" do
      spec_name = "SingleSpecWithPartitionTransformer"
      partition = "Partition1"
      envelope = %Envelope{private: %Private{spec: spec_name}}

      assert %Envelope{
               private: %Private{
                 route_state_id: {^spec_name, @platform_name, ^partition},
                 spec: ^spec_name,
                 platform: @platform_name,
                 partition: ^partition,
                 request_pipeline: @webcore_request_pipeline,
                 response_pipeline: @webcore_response_pipeline,
                 owner: "Some guy",
                 runbook: "Some runbook"
               }
             } = Processor.get_route_spec(envelope)
    end

    test "raises an error when spec has multiple platforms and preflight doesn't update platform" do
      spec_name = "MultipleSpecsNoPlatformReturned"
      envelope = %Envelope{private: %Private{spec: spec_name}}
      err_msg = "Platform '' cannot be matched in '#{spec_name}' spec"

      assert_raise RuntimeError, err_msg, fn -> Processor.get_route_spec(envelope) end
    end

    test "raises an error when spec is not matched on platform" do
      spec_name = "MultipleSpecsFailedPlatformMatch"
      envelope = %Envelope{private: %Private{spec: spec_name}}
      err_msg = "Platform 'Webcore' cannot be matched in '#{spec_name}' spec"

      assert_raise RuntimeError, err_msg, fn -> Processor.get_route_spec(envelope) end
    end

    test "raises an error if route spec is not found" do
      spec_name = "NonExistingSpec"
      envelope = %Envelope{private: %Private{spec: spec_name}}
      err_msg = "Route spec '#{spec_name}' not found"

      assert_raise RuntimeError, err_msg, fn -> Processor.get_route_spec(envelope) end
    end
  end

  describe "pre_request_pipeline/1" do
    @raw_headers %{"webcore-header" => "header-1", "mozartnews-header" => "header-2"}
    @query_params %{"webcore_qparam" => "a", "mozartnews_qparam" => "b"}

    setup do
      clear_cache()
    end

    test "generates cache key based on merged allowlists for a multi-platform spec and successful preflight pipeline result" do
      envelope = %Envelope{
        private: %Private{
          spec: "AssetTypeWithMultipleSpecs"
        },
        request: %Request{
          path: "/dummy/path",
          query_params: @query_params,
          raw_headers: @raw_headers
        }
      }

      route_state_id = {"AssetTypeWithMultipleSpecs", @platform_name}
      hash_envelope = Envelope.add(envelope, :private, %{route_state_id: route_state_id})
      request_hash = RequestHash.generate(hash_envelope)

      with_mock(
        Pipeline,
        process: fn %Envelope{}, :preflight, _ -> mock_ok_preflight_resp(envelope, @platform_name) end
      ) do
        assert %Envelope{
                 private: %Private{
                   route_state_id: ^route_state_id,
                   query_params_allowlist: query_params_allowlist,
                   headers_allowlist: headers_allowlist
                 },
                 request: %Request{
                   request_hash: ^request_hash,
                   raw_headers: @raw_headers,
                   query_params: @query_params
                 }
               } = Processor.pre_request_pipeline(envelope)

        assert Enum.member?(query_params_allowlist, "webcore_qparam")
        assert Enum.member?(query_params_allowlist, "mozartnews_qparam")
        assert Enum.member?(headers_allowlist, "webcore-header")
        assert Enum.member?(headers_allowlist, "mozartnews-header")
      end
    end

    test "allows all query params if allowlist is \"*\" for one spec in a multi-platform spec" do
      envelope = %Envelope{
        private: %Private{
          spec: "SomeRouteStateWithMultipleSpecs"
        },
        request: %Request{
          path: "/dummy/path",
          query_params: @query_params
        }
      }

      route_state_id = {"SomeRouteStateWithMultipleSpecs", @platform_name}
      hash_envelope = Envelope.add(envelope, :private, %{route_state_id: route_state_id})
      request_hash = RequestHash.generate(hash_envelope)

      with_mock(
        Pipeline,
        process: fn %Envelope{}, :preflight, _ -> mock_ok_preflight_resp(envelope, @platform_name) end
      ) do
        assert %Envelope{
                 private: %Private{
                   route_state_id: ^route_state_id,
                   query_params_allowlist: "*"
                 },
                 request: %Request{
                   request_hash: ^request_hash,
                   query_params: @query_params
                 }
               } = Processor.pre_request_pipeline(envelope)
      end
    end

    test "filters headers and query params for a single-platform spec" do
      envelope = %Envelope{
        private: %Private{
          spec: "SingleSpecWithPartitionTransformer"
        },
        request: %Request{
          path: "/dummy/path",
          query_params: @query_params,
          raw_headers: @raw_headers
        }
      }

      assert %Envelope{
               private: %Private{
                 route_state_id: {"SingleSpecWithPartitionTransformer", @platform_name, "Partition1"},
                 headers_allowlist: headers_allowlist,
                 query_params_allowlist: query_params_allowlist
               },
               request: %Request{
                 path: "/dummy/path",
                 request_hash: request_hash,
                 raw_headers: %{"webcore-header" => "header-1"},
                 query_params: %{"webcore_qparam" => "a"}
               }
             } = Processor.pre_request_pipeline(envelope)

      assert Enum.member?(query_params_allowlist, "webcore_qparam")
      assert Enum.member?(headers_allowlist, "webcore-header")
      assert request_hash != nil
    end

    test "use cached response for a single-platform spec as fallback if preflight pipeline failed" do
      resp_body = "Single-spec cached response"
      route_state_id = {"SingleSpecWithPartitionTransformer", @platform_name}

      cached_envelope = %Envelope{
        private: %Private{
          route_state_id: route_state_id,
          spec: "SingleSpecWithPartitionTransformer"
        },
        request: %Request{
          path: "/dummy/path",
          raw_headers: %{"webcore-header" => "header-1"},
          query_params: %{"webcore_qparam" => "a"}
        },
        response: %Response{
          http_status: 200,
          body: resp_body
        }
      }

      put_into_cache(cached_envelope)

      envelope = %Envelope{
        private: %Private{
          spec: "SingleSpecWithPartitionTransformer"
        },
        request: %Request{
          path: "/dummy/path",
          query_params: @query_params,
          raw_headers: @raw_headers
        }
      }

      with_mock(
        Pipeline,
        process: fn %Envelope{}, :preflight, _ -> mock_error_preflight_resp(envelope) end
      ) do
        assert %Envelope{
                 private: %Private{
                   route_state_id: ^route_state_id
                 },
                 request: %Request{
                   raw_headers: %{"webcore-header" => "header-1"},
                   query_params: %{"webcore_qparam" => "a"}
                 },
                 response: %Response{
                   http_status: 200,
                   body: ^resp_body,
                   fallback: true
                 }
               } = Processor.pre_request_pipeline(envelope)
      end
    end

    test "uses cached response based on merged allowlists for a multi-platform spec as fallback if preflight pipeline failed" do
      resp_body = "Multi-spec cached response"

      cached_envelope = %Envelope{
        private: %Private{
          spec: "AssetTypeWithMultipleSpecs"
        },
        request: %Request{
          path: "/dummy/path",
          query_params: @query_params,
          raw_headers: @raw_headers
        },
        response: %Response{
          http_status: 200,
          body: resp_body
        }
      }

      put_into_cache(cached_envelope)

      envelope = %Envelope{
        private: %Private{
          spec: "AssetTypeWithMultipleSpecs"
        },
        request: %Request{
          path: "/dummy/path",
          query_params: @query_params,
          raw_headers: @raw_headers
        }
      }

      with_mock(
        Pipeline,
        process: fn %Envelope{}, :preflight, _ -> mock_error_preflight_resp(envelope) end
      ) do
        assert %Envelope{
                 private: %Private{
                   route_state_id: nil
                 },
                 response: %Response{
                   http_status: 200,
                   body: ^resp_body,
                   fallback: true
                 }
               } = Processor.pre_request_pipeline(envelope)
      end
    end

    test "does not use cached response if preflight pipeline failed and caching is disabled" do
      envelope = %Envelope{
        private: %Private{
          spec: "AssetTypeWithMultipleSpecs"
        },
        request: %Request{
          path: "/dummy/path",
          query_params: @query_params,
          raw_headers: @raw_headers
        }
      }

      with_mock(
        Pipeline,
        process: fn %Envelope{}, :preflight, _ -> mock_error_preflight_resp(envelope) end
      ) do
        assert %Envelope{
                 private: %Private{
                   route_state_id: nil
                 },
                 response: %Response{
                   http_status: 500,
                   fallback: false
                 }
               } = Processor.pre_request_pipeline(envelope)
      end
    end

    defp mock_ok_preflight_resp(envelope, platform) do
      {:ok, Envelope.add(envelope, :private, %{platform: platform})}
    end

    defp mock_error_preflight_resp(envelope), do: {:error, envelope, 500}
  end

  describe "Processor.get_route_state/1" do
    @envelope %Envelope{
      private: %Private{
        route_state_id: @route_state_id,
        origin: "https://origin.bbc.co.uk/"
      }
    }

    test "adds route_state information to Envelope.private" do
      assert %Envelope{
               request: _request,
               private: %Private{
                 route_state_id: @route_state_id,
                 origin: origin,
                 counter: counter,
                 request_pipeline: pipeline
               }
             } = Processor.get_route_state(@envelope)

      assert origin != nil, "Expected an origin value to be provided by the route_state"
      assert counter != nil, "Expected a counter value to be provided by the route_state"
      assert pipeline != nil, "Expected a pipeline value to be provided by the route_state"
    end

    test "keeps Envelope.Private default values when merging in routespec data" do
      assert %Envelope{
               request: _request,
               private: %Private{
                 cookie_allowlist: cookie_allowlist
               }
             } = Processor.get_route_state(@envelope)

      assert cookie_allowlist == []
    end
  end

  describe "Processor.request_pipeline/1" do
    @envelope %Envelope{
      private: %Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        request_pipeline: ["MyTransformer1"]
      }
    }

    test "runs envelope through transformers" do
      assert %{
               request: _request,
               private: _private,
               sample_change: "foo"
             } = Processor.request_pipeline(@envelope)
    end
  end

  describe "Processor.request_pipeline/1 with empty pipeline" do
    @envelope %Envelope{
      private: %Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        request_pipeline: []
      }
    }

    test "returns the unmodified envelope" do
      assert %{
               request: _request,
               private: _private
             } = Processor.request_pipeline(@envelope)
    end
  end

  describe "Processor.response_pipeline/1" do
    @resp_envelope %Envelope{
      request: %Request{
        request_hash: "a-request-hash",
        path: "/news/live"
      },
      response: %Response{
        http_status: 501,
        body: "",
        headers: %{
          "connection" => "close"
        }
      },
      private: %Private{
        response_pipeline: ["CacheDirective", "ResponseHeaderGuardian"]
      }
    }

    test "calls the ResponseHeaderGuardian response transformer" do
      result = Processor.response_pipeline(@resp_envelope)

      refute Map.has_key?(result.response.headers, "connection")
    end
  end

  describe "Processor.response_pipeline/1 on 404 response" do
    @resp_envelope %Envelope{
      response: %Response{
        http_status: 404,
        body: "",
        headers: %{
          "connection" => "close"
        }
      },
      private: %Private{
        response_pipeline: ["CacheDirective"]
      }
    }

    test "it should log a 404 error" do
      log_message =
        capture_log(fn ->
          Processor.response_pipeline(@resp_envelope)
        end)

      assert String.contains?(log_message, "404 error from origin")
    end
  end

  describe "Process.allowlists/1" do
    test "filters out query params not in the allowlist" do
      envelope = %Envelope{
        request: %Request{query_params: %{"allowed" => "yes", "not-allowed" => "yes"}},
        private: %Private{query_params_allowlist: ["allowed"]}
      }

      envelope = Processor.allowlists(envelope)
      assert Map.has_key?(envelope.request.query_params, "allowed")
      refute Map.has_key?(envelope.request.query_params, "not-allowed")
    end

    test "filters out headers not in the allowlist" do
      envelope = %Envelope{
        request: %Request{raw_headers: %{"allowed" => "yes", "not-allowed" => "yes"}},
        private: %Private{headers_allowlist: ["allowed"]}
      }

      envelope = Processor.allowlists(envelope)
      assert Map.has_key?(envelope.request.raw_headers, "allowed")
      refute Map.has_key?(envelope.request.raw_headers, "not-allowed")
    end

    test "filters out cookies not in the allowlist" do
      envelope = %Envelope{
        request: %Request{raw_headers: %{"cookie" => "best=bourbon;worst=custard-cream"}},
        private: %Private{cookie_allowlist: ["best"]}
      }

      assert %{"best" => "bourbon"} == Processor.allowlists(envelope).request.cookies
    end
  end

  describe "fetch_early_response_from_cache/1" do
    setup do
      envelope = %Envelope{request: %Request{request_hash: unique_cache_key()}}
      response = %Response{body: "Cached response"}
      response = put_into_cache(%Envelope{envelope | response: response})
      %{envelope: envelope, cached_response: response}
    end

    test "uses cached response", %{envelope: envelope, cached_response: cached_response} do
      %{response: response} = Processor.fetch_early_response_from_cache(envelope)
      assert response.body == cached_response.body
    end

    test "does not use cached response for personalised requests", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      envelope = Envelope.add(envelope, :private, %{personalised_request: true})

      %{response: response} = Processor.fetch_early_response_from_cache(envelope)
      refute response.body == cached_response.body
    end

    test "does not use cached response for routes requesting not to be cached", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      envelope = Envelope.add(envelope, :private, %{caching_enabled: false})

      %{response: response} = Processor.fetch_early_response_from_cache(envelope)
      refute response.body == cached_response.body
    end
  end

  describe "fetch_fallback_from_cache/1" do
    setup do
      envelope = %Envelope{
        request: %Request{request_hash: unique_cache_key(), request_id: UUID.uuid4(), path: "/news/live"},
        response: %Response{http_status: 200}
      }

      response = %Response{http_status: 200, body: "Cached response"}
      response = put_into_cache(%Envelope{envelope | response: response})
      %{envelope: envelope, cached_response: response}
    end

    test "does not use cached response as fallback for successful response", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      %{response: response} = Processor.fetch_fallback_from_cache(envelope)
      refute response.body == cached_response.body
    end

    test "uses response in local cache as fallback for failed response", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      envelope = Envelope.add(envelope, :response, %{http_status: 500})
      %{response: response} = Processor.fetch_fallback_from_cache(envelope)
      assert response.body == cached_response.body
      assert response.fallback == true
    end

    test "uses stale response in local cache as fallback", %{envelope: envelope} do
      cached_response = make_cached_response_stale(envelope.request.request_hash)

      envelope = Envelope.add(envelope, :response, %{http_status: 500})
      %{response: response} = Processor.fetch_fallback_from_cache(envelope)
      assert response == %{cached_response | fallback: true, cache_type: :local}
    end

    test "uses response in distributed cache as fallback for failed response", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      clear_cache()

      expect(Belfrage.Clients.CCPMock, :fetch, fn _envelope ->
        {:ok, cached_response}
      end)

      envelope = Envelope.add(envelope, :response, %{http_status: 500})
      %{response: response} = Processor.fetch_fallback_from_cache(envelope)
      assert response.body == cached_response.body
      assert response.fallback == true
      assert response.cache_type == :distributed
    end

    test "fallback for personalised request returns non-personalised content and a private response", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      envelope =
        envelope
        |> Envelope.add(:response, %{http_status: 500})
        |> Envelope.add(:private, %{personalised_request: true})

      %{response: response} = Processor.fetch_fallback_from_cache(envelope)
      assert response.body == cached_response.body
      assert response.cache_directive.cacheability == "private"
    end

    test "tracks latency checkpoints when fetching fallback", %{envelope: envelope} do
      envelope = Envelope.add(envelope, :response, %{http_status: 500})
      envelope = Processor.fetch_fallback_from_cache(envelope)

      checkpoints = LatencyMonitor.get_checkpoints(envelope)
      assert checkpoints[:fallback_request_sent]
      assert checkpoints[:fallback_response_received]
      assert checkpoints[:fallback_response_received] > checkpoints[:fallback_request_sent]
    end
  end

  describe "use_fallback?/1" do
    def envelope_fixture(status: status, caching_enabled: caching_enabled) do
      %Envelope{response: %Response{http_status: status}, private: %Private{caching_enabled: caching_enabled}}
    end

    test "returns true for server errors and most client errors" do
      assert Processor.use_fallback?(envelope_fixture(status: 500, caching_enabled: true))
      assert Processor.use_fallback?(envelope_fixture(status: 503, caching_enabled: true))

      assert Processor.use_fallback?(envelope_fixture(status: 400, caching_enabled: true))
      assert Processor.use_fallback?(envelope_fixture(status: 403, caching_enabled: true))
      assert Processor.use_fallback?(envelope_fixture(status: 429, caching_enabled: true))
    end

    test "returns false for some client errors" do
      refute Processor.use_fallback?(envelope_fixture(status: 401, caching_enabled: true))
      refute Processor.use_fallback?(envelope_fixture(status: 404, caching_enabled: true))
      refute Processor.use_fallback?(envelope_fixture(status: 410, caching_enabled: true))
      refute Processor.use_fallback?(envelope_fixture(status: 451, caching_enabled: true))
    end

    test "returns false if envelope.private.caching_enabled is false" do
      refute Processor.use_fallback?(envelope_fixture(status: 500, caching_enabled: false))
      refute Processor.use_fallback?(envelope_fixture(status: 404, caching_enabled: false))
    end
  end
end
