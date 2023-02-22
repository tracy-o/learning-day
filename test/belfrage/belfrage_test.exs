defmodule BelfrageTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Response, Private}
  alias Belfrage.Clients.LambdaMock
  alias Belfrage.Metrics.LatencyMonitor

  import Test.Support.Helper, only: [assert_gzipped: 2]

  @route_state_id {"SportArticlePage", "Webcore"}

  @get_request_envelope %Envelope{
    private: %Private{
      route_state_id: @route_state_id,
      production_environment: "test"
    },
    request: %Request{
      path: "/_web_core",
      method: "GET",
      country: "gb",
      request_id: "gerald-the-get-request"
    }
  }

  @web_core_lambda_response {:ok, %{"body" => "Some content", "headers" => %{}, "statusCode" => 200}}
  @web_core_404_lambda_response {:ok, %{"body" => "404 - not found", "headers" => %{}, "statusCode" => 404}}
  @web_core_500_lambda_response {:ok, %{"body" => "500 - internal error", "headers" => %{}, "statusCode" => 500}}

  setup do
    start_supervised!({Belfrage.RouteState, @route_state_id})
    :ok
  end

  test "GET request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_func = "pwa-lambda-function:test",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@get_request_envelope)
  end

  test "GET request on a subdomain and preview_mode, invokes lambda with the lambda alias" do
    envelope = Envelope.add(@get_request_envelope, :request, %{subdomain: "example-branch"})
    envelope = Envelope.add(envelope, :private, %{preview_mode: "on"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_func = "pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(envelope)
  end

  test "GET request on a subdomain and preview_mode with no matching alias, invokes lambda with the lambda alias and returns the 404 response" do
    envelope = Envelope.add(@get_request_envelope, :request, %{subdomain: "example-branch"})
    envelope = Envelope.add(envelope, :private, %{preview_mode: "on"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_func = "pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _opts = [] ->
      @web_core_404_lambda_response
    end)

    thing = Belfrage.handle(envelope)

    assert thing.response.http_status == 404
    assert thing.response.body == "404 - not found"
  end

  test "increments the route_state when request has 200 status and no MVT vary headers" do
    LambdaMock
    |> expect(:call, 1, fn _credentials,
                           _lambda_func = "pwa-lambda-function:test",
                           _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                           _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@get_request_envelope)

    {:ok, state} = Belfrage.RouteState.state(@route_state_id)

    assert state.counter == %{
             "pwa-lambda-function:test" => %{200 => 1, :errors => 0}
           }
  end

  test "updates the route_state when request has 200 status and MVT vary headers" do
    LambdaMock
    |> expect(:call, 1, fn _credentials,
                           _lambda_func = "pwa-lambda-function:test",
                           _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                           _opts = [] ->
      {:ok,
       %{
         "body" => "Some content",
         "headers" => %{
           "vary" => "something,mvt-button-colour,something-else,mvt-sidebar-colour"
         },
         "statusCode" => 200
       }}
    end)

    Belfrage.handle(@get_request_envelope)

    {:ok, state} = Belfrage.RouteState.state(@route_state_id)

    assert state.counter == %{
             "pwa-lambda-function:test" => %{200 => 1, :errors => 0}
           }

    assert ["mvt-button-colour", "mvt-sidebar-colour"] = Map.keys(state.mvt_seen)
    assert state.mvt_seen["mvt-button-colour"] == state.mvt_seen["mvt-sidebar-colour"]
    assert :gt == DateTime.compare(DateTime.utc_now(), state.mvt_seen["mvt-sidebar-colour"])
  end

  test "increments the route_state when request has 500 status" do
    LambdaMock
    |> expect(:call, 1, fn _credentials,
                           _lambda_func = "pwa-lambda-function:test",
                           _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                           _opts = [] ->
      @web_core_500_lambda_response
    end)

    Belfrage.handle(@get_request_envelope)

    {:ok, state} = Belfrage.RouteState.state(@route_state_id)

    assert state.counter == %{
             :errors => 1,
             "pwa-lambda-function:test" => %{500 => 1, :errors => 1}
           }
  end

  describe "with seeded cache" do
    setup do
      envelope =
        @get_request_envelope
        |> Envelope.add(:request, %{path: "/_seeded_cache"})

      put_into_cache(%Envelope{
        envelope
        | response: %Response{
            body: :zlib.gzip(~s({"hi": "bonjour"})),
            headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
      })

      %{envelope: envelope}
    end

    test "returns cached response", %{envelope: envelope} do
      envelope = Envelope.add(envelope, :request, %{accept_encoding: "gzip, br, deflate"})

      assert %Envelope{
               response: %Response{
                 body: compressed_body,
                 headers: %{
                   "content-encoding" => "gzip"
                 }
               }
             } = Belfrage.handle(envelope)

      assert_gzipped(compressed_body, ~s({"hi": "bonjour"}))
    end

    test "decompresses cached response if client doesn't accept compression", %{envelope: envelope} do
      assert %Envelope{
               response: %Response{
                 body: ~s({"hi": "bonjour"}),
                 headers: headers
               }
             } = Belfrage.handle(envelope)

      refute Map.has_key?(headers, "content-encoding")
    end

    test "records latency checkpoint", %{envelope: envelope} do
      envelope = Belfrage.handle(envelope)

      checkpoints = LatencyMonitor.get_checkpoints(envelope)
      assert checkpoints[:early_response_received]
    end

    test "increments the route_state, when fetching from cache", %{envelope: envelope} do
      LambdaMock
      |> expect(:call, 0, fn _credentials,
                             _lambda_func = "pwa-lambda-function:test",
                             _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                             _opts = [] ->
        flunk("This should never be called")
      end)

      Belfrage.handle(envelope)

      %Private{route_state_id: route_state_id} = envelope.private
      {:ok, state} = Belfrage.RouteState.state(route_state_id)

      assert state.counter.belfrage_cache == %{200 => 1, :errors => 0}
    end
  end

  describe "seeded with stale cache" do
    setup do
      envelope =
        @get_request_envelope
        |> Envelope.add(:request, %{path: "/_stale_seeded_cache"})

      put_into_cache_as_stale(%Envelope{
        envelope
        | response: %Response{
            body: :zlib.gzip(~s({"hi": "bonjour"})),
            headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
      })

      %{envelope: envelope}
    end

    test "increments the route_state, when fetching from fallback", %{envelope: envelope} do
      LambdaMock
      |> expect(:call, 1, fn _credentials,
                             _lambda_func = "pwa-lambda-function:test",
                             _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                             _opts = [] ->
        @web_core_500_lambda_response
      end)

      Belfrage.handle(envelope)

      %Private{route_state_id: route_state_id} = envelope.private
      {:ok, state} = Belfrage.RouteState.state(route_state_id)

      assert state.counter == %{
               :errors => 1,
               "pwa-lambda-function:test" => %{500 => 1, :errors => 1, :fallback => 1}
             }
    end
  end
end
