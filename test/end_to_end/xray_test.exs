defmodule EndToEnd.XrayTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  import Belfrage.Test.MetricsHelper

  alias BelfrageWeb.Router
  alias Belfrage.{Clients.HTTP, RouteState}

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  describe "request goes through webcore service" do
    setup do
      start_supervised!({RouteState, "SomeRouteState"})
      :ok
    end

    test "a webcore.request.stop event is emmited (triggers subsegment creation)" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _lambda_name, _role_arn, _payload, _request_id, _opts ->
        {:ok, @lambda_response}
      end)

      assert {_event, %{start_time: _start_time, duration: _duration}, _metadata} =
               intercept_metric(~w(webcore request stop)a, fn ->
                 conn(:get, "/200-ok-response")
                 |> Router.call([])
               end)
    end

    test "has trace_id in the opts" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _lambda_name, _role_arn, _payload, _request_id, [xray_trace_id: trace_id] ->
        assert trace_id
        {:ok, @lambda_response}
      end)

      conn(:get, "/200-ok-response")
      |> Router.call([])
    end
  end

  describe "hitting the fabl endpoint" do
    setup do
      start_supervised!({RouteState, "SomeFablRouteState"})
      :ok
    end

    test "when start_trace/1 is successful, fabl headers contain x-amzn-trace-id" do
      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn %HTTP.Request{headers: headers}, :Fabl ->
        assert Map.has_key?(headers, "x-amzn-trace-id")
        assert String.contains?(headers["x-amzn-trace-id"], "Sampled=")
        assert String.contains?(headers["x-amzn-trace-id"], "Root=")
        assert String.contains?(headers["x-amzn-trace-id"], "Parent=")

        {:ok,
         %HTTP.Response{
           headers: %{"cache-control" => "public, max-age=60"},
           status_code: 200,
           body: ""
         }}
      end)

      conn = conn(:get, "/fabl/xray") |> Router.call([])
      {200, _, _} = sent_resp(conn)
    end
  end
end
