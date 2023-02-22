defmodule Belfrage.ProcessorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog
  import Belfrage.Test.CachingHelper

  alias Belfrage.{Processor, Envelope}
  alias Belfrage.Envelope.{Request, Response, Private}
  alias Belfrage.Metrics.LatencyMonitor

  @route_state_id {"SportVideos", "Webcore"}

  defmodule Module.concat([Routes, Specs, SomePersonalisedRouteState]) do
    def specs do
      %{
        platform: "Webcore",
        personalisation: "test_only",
        response_pipeline: ["CacheDirective"]
      }
    end
  end

  describe "Processor.get_route_state/1" do
    @envelope %Envelope{private: %Private{route_state_id: @route_state_id}}

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
        request: %Request{request_hash: unique_cache_key(), request_id: UUID.uuid4()},
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
