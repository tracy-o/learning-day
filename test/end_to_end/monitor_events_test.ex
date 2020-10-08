defmodule EndToEnd.MonitorEventsTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router

  @moduletag :end_to_end

  setup do
    Belfrage.Clients.LambdaMock
    |> stub(:call, fn _role_arn, _function, _payload, _opts ->
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
    end)

    conn = conn(:get, "/200-ok-response?belfrage-cache-bust")
    conn = Router.call(conn, [])
  end

  describe "a freshed cached response" do
    setup do
      conn = conn(:get, "/200-ok-response")
      conn = Router.call(conn, [])

      :ok
    end

    test "sends metrics and logs to monitor" do
      Belfrage.MonitorMock
      |> expect(:record_event, 2, fn
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
      end)

      conn = conn(:get, "/200-ok-response")
      conn = Router.call(conn, [])
    end
  end
end
