defmodule BelfrageTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Response, Private}
  alias Belfrage.Clients.LambdaMock
  alias Belfrage.Metrics.LatencyMonitor

  import Test.Support.Helper, only: [assert_gzipped: 2]

  @route_state_id "SportArticlePage"

  @get_request_struct %Struct{
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

  @post_request_struct %Struct{
    request: %Request{
      path: "/",
      method: "POST",
      payload: ~s({"some": "data please"}),
      country: "gb",
      request_id: "pete-the-post-request"
    },
    private: %Private{
      route_state_id: @route_state_id,
      production_environment: "test"
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
                        _request_id = "gerald-the-get-request",
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@get_request_struct)
  end

  test "GET request on a subdomain and preview_mode, invokes lambda with the lambda alias" do
    struct = Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})
    struct = Struct.add(struct, :private, %{preview_mode: "on"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_func = "pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _request_id = "gerald-the-get-request",
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(struct)
  end

  test "GET request on a subdomain and preview_mode with no matching alias, invokes lambda with the lambda alias and returns the 404 response" do
    struct = Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})
    struct = Struct.add(struct, :private, %{preview_mode: "on"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_func = "pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _request_id = "gerald-the-get-request",
                        _opts = [] ->
      @web_core_404_lambda_response
    end)

    thing = Belfrage.handle(struct)

    assert thing.response.http_status == 404
    assert thing.response.body == "404 - not found"
  end

  test "POST request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_func = "pwa-lambda-function:test",
                        _payload = %{
                          body: ~s({"some": "data please"}),
                          headers: %{country: "gb"},
                          httpMethod: "POST"
                        },
                        _request_id = "pete-the-post-request",
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@post_request_struct)
  end

  @redirect_request_struct %Struct{
    private: %Private{
      route_state_id: "SportVideos"
    },
    request: %Request{
      path: "/_web_core",
      method: "GET",
      country: "gb",
      host: "www.bbc.com",
      scheme: :http,
      request_id: "ronnie-the-redirect"
    }
  }

  test "A HTTP request redirects to https, and doesn't call the lambda" do
    LambdaMock
    |> expect(:call, 0, fn _credentials, _func_name, _payload, _request_id, _opts -> :this_should_not_be_called end)

    response_struct = Belfrage.handle(@redirect_request_struct)

    assert response_struct.response.http_status == 302
  end

  test "increments the route_state when request has 200 status and no MVT vary headers" do
    LambdaMock
    |> expect(:call, 1, fn _credentials,
                           _lambda_func = "pwa-lambda-function:test",
                           _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                           _request_id = "gerald-the-get-request",
                           _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@get_request_struct)

    {:ok, state} = Belfrage.RouteState.state(@get_request_struct)

    assert state.counter == %{
             "pwa-lambda-function:test" => %{200 => 1, :errors => 0}
           }
  end

  test "updates the route_state when request has 200 status and MVT vary headers" do
    LambdaMock
    |> expect(:call, 1, fn _credentials,
                           _lambda_func = "pwa-lambda-function:test",
                           _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                           _request_id = "gerald-the-get-request",
                           _opts = [] ->
      {:ok,
       %{
         "body" => "Some content",
         "headers" => %{
           "vary" => "something,mvt-button-colour,something-else,mvt-sidear-colour"
         },
         "statusCode" => 200
       }}
    end)

    Belfrage.handle(@get_request_struct)

    {:ok, state} = Belfrage.RouteState.state(@get_request_struct)

    assert state.counter == %{
             "pwa-lambda-function:test" => %{200 => 1, :errors => 0}
           }

    assert [{:"mvt-sidear-colour", dt1}, {:"mvt-button-colour", dt2}] = state.mvt_seen
    assert dt2 == dt1
    assert :gt == DateTime.compare(DateTime.utc_now(), dt1)
  end

  test "increments the route_state when request has 500 status" do
    LambdaMock
    |> expect(:call, 1, fn _credentials,
                           _lambda_func = "pwa-lambda-function:test",
                           _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                           _request_id = "gerald-the-get-request",
                           _opts = [] ->
      @web_core_500_lambda_response
    end)

    Belfrage.handle(@get_request_struct)

    {:ok, state} = Belfrage.RouteState.state(@get_request_struct)

    assert state.counter == %{
             :errors => 1,
             "pwa-lambda-function:test" => %{500 => 1, :errors => 1}
           }
  end

  describe "with seeded cache" do
    setup do
      struct =
        @get_request_struct
        |> Struct.add(:request, %{path: "/_seeded_cache"})

      put_into_cache(%Struct{
        struct
        | response: %Response{
            body: :zlib.gzip(~s({"hi": "bonjour"})),
            headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
      })

      %{struct: struct}
    end

    test "returns cached response", %{struct: struct} do
      struct = Struct.add(struct, :request, %{accept_encoding: "gzip, br, deflate"})

      assert %Struct{
               response: %Response{
                 body: compressed_body,
                 headers: %{
                   "content-encoding" => "gzip"
                 }
               }
             } = Belfrage.handle(struct)

      assert_gzipped(compressed_body, ~s({"hi": "bonjour"}))
    end

    test "decompresses cached response if client doesn't accept compression", %{struct: struct} do
      assert %Struct{
               response: %Response{
                 body: ~s({"hi": "bonjour"}),
                 headers: headers
               }
             } = Belfrage.handle(struct)

      refute Map.has_key?(headers, "content-encoding")
    end

    test "records latency checkpoint", %{struct: struct} do
      start_supervised!(LatencyMonitor)

      Belfrage.handle(struct)

      checkpoints = LatencyMonitor.get_checkpoints(struct.request.request_id)
      assert checkpoints[:early_response_received]
    end

    test "increments the route_state, when fetching from cache", %{struct: struct} do
      LambdaMock
      |> expect(:call, 0, fn _credentials,
                             _lambda_func = "pwa-lambda-function:test",
                             _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                             _request_id = "gerald-the-get-request",
                             _opts = [] ->
        flunk("This should never be called")
      end)

      Belfrage.handle(struct)

      {:ok, state} = Belfrage.RouteState.state(struct)

      assert state.counter.belfrage_cache == %{200 => 1, :errors => 0}
    end
  end

  describe "seeded with stale cache" do
    setup do
      struct =
        @get_request_struct
        |> Struct.add(:request, %{path: "/_stale_seeded_cache"})

      put_into_cache_as_stale(%Struct{
        struct
        | response: %Response{
            body: :zlib.gzip(~s({"hi": "bonjour"})),
            headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
      })

      %{struct: struct}
    end

    test "increments the route_state, when fetching from fallback", %{struct: struct} do
      LambdaMock
      |> expect(:call, 1, fn _credentials,
                             _lambda_func = "pwa-lambda-function:test",
                             _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                             _request_id = "gerald-the-get-request",
                             _opts = [] ->
        @web_core_500_lambda_response
      end)

      Belfrage.handle(struct)

      {:ok, state} = Belfrage.RouteState.state(struct)

      assert state.counter == %{
               :errors => 1,
               "pwa-lambda-function:test" => %{500 => 1, :errors => 1, :fallback => 1}
             }
    end
  end
end
