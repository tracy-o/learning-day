defmodule Belfrage.ProcessorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog
  import Belfrage.Test.CachingHelper

  alias Belfrage.{Processor, Struct}
  alias Belfrage.Struct.{Request, Response, Private}
  alias Belfrage.Metrics.LatencyMonitor

  defmodule Module.concat([Routes, Specs, SomePersonalisedRouteState]) do
    def specs do
      %{
        platform: Webcore,
        personalisation: "test_only"
      }
    end
  end

  describe "Processor.get_route_state/1" do
    @struct %Struct{private: %Private{route_state_id: "SportVideos"}}

    test "adds route_state information to Struct.private" do
      assert %Struct{
               request: _request,
               private: %Private{
                 route_state_id: "SportVideos",
                 origin: origin,
                 counter: counter,
                 pipeline: pipeline
               }
             } = Processor.get_route_state(@struct)

      assert origin != nil, "Expected an origin value to be provided by the route_state"
      assert counter != nil, "Expected a counter value to be provided by the route_state"
      assert pipeline != nil, "Expected a pipeline value to be provided by the route_state"
    end

    test "keeps Struct.Private default values when merging in routespec data" do
      assert %Struct{
               request: _request,
               private: %Private{
                 cookie_allowlist: cookie_allowlist
               }
             } = Processor.get_route_state(@struct)

      assert cookie_allowlist == []
    end
  end

  describe "Processor.request_pipeline/1" do
    @struct %Struct{
      private: %Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        pipeline: ["MyTransformer1"]
      }
    }

    test "runs struct through transformers" do
      assert %{
               request: _request,
               private: _private,
               sample_change: "foo"
             } = Processor.request_pipeline(@struct)
    end
  end

  describe "Processor.request_pipeline/1 with empty pipeline" do
    @struct %Struct{
      private: %Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        pipeline: []
      }
    }

    test "returns the unmodified struct" do
      assert %{
               request: _request,
               private: _private
             } = Processor.request_pipeline(@struct)
    end
  end

  describe "Processor.response_pipeline/1" do
    @resp_struct %Struct{
      response: %Response{
        http_status: 501,
        body: "",
        headers: %{
          "connection" => "close"
        }
      }
    }

    test "calls the ResponseHeaderGuardian response transformer" do
      result = Processor.response_pipeline(@resp_struct)

      refute Map.has_key?(result.response.headers, "connection")
    end
  end

  describe "Processor.response_pipeline/1 on 404 response" do
    @resp_struct %Struct{
      response: %Response{
        http_status: 404,
        body: "",
        headers: %{
          "connection" => "close"
        }
      }
    }

    test "it should log a 404 error" do
      log_message =
        capture_log(fn ->
          Processor.response_pipeline(@resp_struct)
        end)

      assert String.contains?(log_message, "404 error from origin")
    end
  end

  describe "Process.allowlists/1" do
    test "filters out query params not in the allowlist" do
      struct = %Struct{
        request: %Request{query_params: %{"allowed" => "yes", "not-allowed" => "yes"}},
        private: %Private{query_params_allowlist: ["allowed"]}
      }

      struct = Processor.allowlists(struct)
      assert Map.has_key?(struct.request.query_params, "allowed")
      refute Map.has_key?(struct.request.query_params, "not-allowed")
    end

    test "filters out headers not in the allowlist" do
      struct = %Struct{
        request: %Request{raw_headers: %{"allowed" => "yes", "not-allowed" => "yes"}},
        private: %Private{headers_allowlist: ["allowed"]}
      }

      struct = Processor.allowlists(struct)
      assert Map.has_key?(struct.request.raw_headers, "allowed")
      refute Map.has_key?(struct.request.raw_headers, "not-allowed")
    end

    test "filters out cookies not in the allowlist" do
      struct = %Struct{
        request: %Request{raw_headers: %{"cookie" => "best=bourbon;worst=custard-cream"}},
        private: %Private{cookie_allowlist: ["best"]}
      }

      assert %{"best" => "bourbon"} == Processor.allowlists(struct).request.cookies
    end
  end

  describe "fetch_early_response_from_cache/1" do
    setup do
      struct = %Struct{request: %Request{request_hash: unique_cache_key()}}
      response = %Response{body: "Cached response"}
      response = put_into_cache(%Struct{struct | response: response})
      %{struct: struct, cached_response: response}
    end

    test "uses cached response", %{struct: struct, cached_response: cached_response} do
      %{response: response} = Processor.fetch_early_response_from_cache(struct)
      assert response.body == cached_response.body
    end

    test "does not use cached response for personalised requests", %{struct: struct, cached_response: cached_response} do
      struct = Struct.add(struct, :private, %{personalised_request: true})

      %{response: response} = Processor.fetch_early_response_from_cache(struct)
      refute response.body == cached_response.body
    end

    test "does not use cached response for routes requesting not to be cached", %{
      struct: struct,
      cached_response: cached_response
    } do
      struct = Struct.add(struct, :private, %{caching_enabled: false})

      %{response: response} = Processor.fetch_early_response_from_cache(struct)
      refute response.body == cached_response.body
    end
  end

  describe "fetch_fallback_from_cache/1" do
    setup do
      struct = %Struct{
        request: %Request{request_hash: unique_cache_key(), request_id: UUID.uuid4()},
        response: %Response{http_status: 200}
      }

      response = %Response{http_status: 200, body: "Cached response"}
      response = put_into_cache(%Struct{struct | response: response})
      %{struct: struct, cached_response: response}
    end

    test "does not use cached response as fallback for successful response", %{
      struct: struct,
      cached_response: cached_response
    } do
      %{response: response} = Processor.fetch_fallback_from_cache(struct)
      refute response.body == cached_response.body
    end

    test "uses response in local cache as fallback for failed response", %{
      struct: struct,
      cached_response: cached_response
    } do
      struct = Struct.add(struct, :response, %{http_status: 500})
      %{response: response} = Processor.fetch_fallback_from_cache(struct)
      assert response == cached_response
    end

    test "uses stale response in local cache as fallback", %{struct: struct} do
      cached_response = make_cached_response_stale(struct.request.request_hash)

      struct = Struct.add(struct, :response, %{http_status: 500})
      %{response: response} = Processor.fetch_fallback_from_cache(struct)
      assert response == %{cached_response | fallback: true, cache_type: :local}
    end

    test "uses response in distributed cache as fallback for failed response", %{
      struct: struct,
      cached_response: cached_response
    } do
      clear_cache()

      expect(Belfrage.Clients.CCPMock, :fetch, fn _struct ->
        {:ok, cached_response}
      end)

      struct = Struct.add(struct, :response, %{http_status: 500})
      %{response: response} = Processor.fetch_fallback_from_cache(struct)
      assert response.body == cached_response.body
      assert response.fallback == true
      assert response.cache_type == :distributed
    end

    test "makes the response private if request is personalised", %{struct: struct, cached_response: cached_response} do
      struct =
        struct
        |> Struct.add(:response, %{http_status: 500})
        |> Struct.add(:private, %{personalised_request: true})

      %{response: response} = Processor.fetch_fallback_from_cache(struct)
      assert response.body == cached_response.body
      assert response.cache_directive.cacheability == "private"
    end

    test "tracks latency checkpoints when fetching fallback", %{struct: struct} do
      start_supervised!(LatencyMonitor)

      struct = Struct.add(struct, :response, %{http_status: 500})
      Processor.fetch_fallback_from_cache(struct)

      checkpoints = LatencyMonitor.get_checkpoints(struct.request.request_id)
      assert checkpoints[:fallback_request_sent]
      assert checkpoints[:fallback_response_received]
      assert checkpoints[:fallback_response_received] > checkpoints[:fallback_request_sent]
    end
  end

  describe "use_fallback?/1" do
    def struct_fixture(status: status, caching_enabled: caching_enabled) do
      %Struct{response: %Response{http_status: status}, private: %Private{caching_enabled: caching_enabled}}
    end

    test "returns true for server errors and most client errors" do
      assert Processor.use_fallback?(struct_fixture(status: 500, caching_enabled: true))
      assert Processor.use_fallback?(struct_fixture(status: 503, caching_enabled: true))

      assert Processor.use_fallback?(struct_fixture(status: 400, caching_enabled: true))
      assert Processor.use_fallback?(struct_fixture(status: 403, caching_enabled: true))
      assert Processor.use_fallback?(struct_fixture(status: 429, caching_enabled: true))
    end

    test "returns false for some client errors" do
      refute Processor.use_fallback?(struct_fixture(status: 404, caching_enabled: true))
      refute Processor.use_fallback?(struct_fixture(status: 410, caching_enabled: true))
      refute Processor.use_fallback?(struct_fixture(status: 451, caching_enabled: true))
    end

    test "returns false if struct.private.caching_enabled is false" do
      refute Processor.use_fallback?(struct_fixture(status: 500, caching_enabled: false))
      refute Processor.use_fallback?(struct_fixture(status: 404, caching_enabled: false))
    end
  end
end
