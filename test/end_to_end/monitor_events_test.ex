defmodule EndToEnd.MonitorEventsTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias BelfrageWeb.Router

  @moduletag :end_to_end

  setup do
    clear_cache()

    Belfrage.Clients.LambdaMock
    |> stub(:call, fn _role_arn, _function, _payload, _request_id, _opts ->
      {:ok,
       %{
         "headers" => %{
           "cache-control" => "public, max-age=30"
         },
         "statusCode" => 200,
         "body" => "<h1>Hello from the Lambda!</h1>"
       }}
    end)

    :ok
  end

  test "records monitor events for using a lambda service" do
    Belfrage.MonitorMock
    |> expect(:record_event, 6, fn
      %Belfrage.Event{
        data: %{method: "GET", path: "/200-ok-response", req_headers: _, resp_headers: _, status: 200},
        dimensions: %{
          request_id: request_id,
          path: "/200-ok-response",
          loop_id: "SomeLoop"
        },
        request_id: request_id,
        type: {:log, :info}
      } ->
        assert is_binary(request_id)

      %Belfrage.Event{
        data: {"service.lambda.response.200", 1},
        dimensions: %{
          request_id: request_id,
          path: "/200-ok-response",
          loop_id: "SomeLoop"
        },
        request_id: request_id,
        type: {:metric, :increment}
      } ->
        assert is_binary(request_id)

      %Belfrage.Event{
        data: {"cache.local.miss", 1},
        dimensions: %{
          request_id: request_id,
          path: "/200-ok-response",
          loop_id: "SomeLoop"
        },
        request_id: request_id,
        type: {:metric, :increment}
      } ->
        assert is_binary(request_id)

      %Belfrage.Event{
        data: {"Elixir.Webcore.pre_cache_compression", 1},
        dimensions: %{
          request_id: request_id,
          path: "/200-ok-response",
          loop_id: "SomeLoop"
        },
        request_id: request_id,
        type: {:metric, :increment}
      } ->
        assert is_binary(request_id)

      %Belfrage.Event{
        data: %{msg: "Content was pre-cache compressed", path: "/200-ok-response", platform: Webcore},
        dimensions: %{
          request_id: request_id,
          path: "/200-ok-response",
          loop_id: "SomeLoop"
        },
        request_id: request_id,
        type: {:log, :info}
      } ->
        assert is_binary(request_id)

      %Belfrage.Event{
        data: {"web.response.uncompressed", 1},
        dimensions: %{
          request_id: request_id,
          path: "/200-ok-response",
          loop_id: "SomeLoop"
        },
        request_id: request_id,
        type: {:metric, :increment}
      } ->
        assert is_binary(request_id)
    end)

    conn = conn(:get, "/200-ok-response?belfrage-cache-bust")
    Router.call(conn, [])
  end

  describe "a fresh cache response" do
    setup do
      conn = conn(:get, "/200-ok-response")
      Router.call(conn, [])

      :ok
    end

    test "sends metrics and logs to monitor" do
      Belfrage.MonitorMock
      |> expect(:record_event, 3, fn
        %Belfrage.Event{
          data: %{method: "GET", path: "/200-ok-response", req_headers: _, resp_headers: _, status: 200},
          dimensions: %{
            request_id: request_id,
            path: "/200-ok-response",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:log, :info}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"cache.local.fresh.hit", 1},
          dimensions: %{
            request_id: request_id,
            path: "/200-ok-response",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"web.response.uncompressed", 1},
          dimensions: %{
            request_id: request_id,
            path: "/200-ok-response",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)
      end)

      conn = conn(:get, "/200-ok-response")
      Router.call(conn, [])
    end
  end

  describe "when a local fallback is served" do
    setup do
      put_into_cache("ecd8bc630a0757b4ccd2b53a15639219", %Belfrage.Struct.Response{
        body: :zlib.gzip(~s({"hi": "bonjour"})),
        headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
        http_status: 200,
        cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 0},
        cache_last_updated: Belfrage.Timer.now_ms() - 1_000
      })

      :ok
    end

    test "sends events to the monitor app" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _function, _payload, _request_id, _opts ->
        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public, max-age=5"
           },
           "statusCode" => 500,
           "body" => "<h1>oh no, this broke!</h1>"
         }}
      end)

      Belfrage.MonitorMock
      |> expect(:record_event, 5, fn
        %Belfrage.Event{
          data: %{method: "GET", path: "/sends-request-downstream", req_headers: _, resp_headers: _, status: 200},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:log, :info}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"service.lambda.response.500", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"cache.local.miss", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"cache.local.stale.hit", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"web.response.uncompressed", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)
      end)

      conn = conn(:get, "/sends-request-downstream")
      Router.call(conn, [])
    end
  end

  describe "when a distributed fallback can be served" do
    setup do
      Belfrage.Clients.CCPMock
      |> expect(:fetch, fn _request_hash, _request_id ->
        {:ok, :stale,
         %Belfrage.Struct.Response{
           body: :zlib.gzip(~s({"hi": "bonjour"})),
           headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
           http_status: 200,
           cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
           cache_last_updated: Belfrage.Timer.now_ms()
         }}
      end)

      :ok
    end

    test "sends events to the monitor app" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _function, _payload, _request_id, _opts ->
        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public, max-age=5"
           },
           "statusCode" => 500,
           "body" => "<h1>oh no, this broke!</h1>"
         }}
      end)

      Belfrage.MonitorMock
      |> expect(:record_event, 6, fn
        %Belfrage.Event{
          data: %{method: "GET", path: "/downstream-broken", req_headers: _, resp_headers: _, status: 200},
          dimensions: %{
            request_id: request_id,
            path: "/downstream-broken",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:log, :info}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"service.lambda.response.500", 1},
          dimensions: %{
            request_id: request_id,
            path: "/downstream-broken",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"cache.local.miss", 1},
          dimensions: %{
            request_id: request_id,
            path: "/downstream-broken",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"cache.distributed.stale.hit", 1},
          dimensions: %{
            request_id: request_id,
            path: "/downstream-broken",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"web.response.uncompressed", 1},
          dimensions: %{
            request_id: request_id,
            path: "/downstream-broken",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)
      end)

      conn = conn(:get, "/downstream-broken?belfrage-cache-bust")
      Router.call(conn, [])
    end
  end

  describe "when a distributed fallback cannot be served" do
    test "sends events to the monitor app" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _function, _payload, _request_id, _opts ->
        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public, max-age=5"
           },
           "statusCode" => 500,
           "body" => "<h1>oh no, this broke!</h1>"
         }}
      end)

      Belfrage.MonitorMock
      |> expect(:record_event, 5, fn
        %Belfrage.Event{
          data: %{method: "GET", path: "/sends-request-downstream", req_headers: _, resp_headers: _, status: 500},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:log, :info}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"service.lambda.response.500", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"cache.local.miss", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"cache.distributed.miss", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)

        %Belfrage.Event{
          data: {"web.response.uncompressed", 1},
          dimensions: %{
            request_id: request_id,
            path: "/sends-request-downstream",
            loop_id: "SomeLoop"
          },
          request_id: request_id,
          type: {:metric, :increment}
        } ->
          assert is_binary(request_id)
      end)

      conn = conn(:get, "/sends-request-downstream?belfrage-cache-bust")
      Router.call(conn, [])
    end
  end

  describe "when the monitor_enabled dial is set to false" do
    test "monitor receives no data" do
      stub(Belfrage.Dials.ServerMock, :state, fn :monitor_enabled ->
        Belfrage.Dials.MonitorEnabled.transform("false")
      end)

      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _function, _payload, _request_id, _opts ->
        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public, max-age=5"
           },
           "statusCode" => 500,
           "body" => "<h1>oh no, this broke!</h1>"
         }}
      end)

      Belfrage.MonitorMock
      |> expect(:record_event, 5, fn _ ->
        {:ok, false}
      end)

      conn = conn(:get, "/200-ok-response")
      Router.call(conn, [])
    end
  end
end
