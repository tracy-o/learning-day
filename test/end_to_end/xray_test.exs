defmodule EndToEnd.XrayTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  import Belfrage.Test.MetricsHelper
  import Test.Support.Helper, only: [set_env: 3]

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
      |> expect(:call, fn _lambda_name, _role_arn, _payload, _opts ->
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
      |> expect(:call, fn _lambda_name, _role_arn, _payload, [xray_trace_id: trace_id] ->
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

      conn =
        conn(:get, "/fabl/xray")
        |> Plug.Conn.put_req_header("user-agent", "Mozilla/5.0")
        |> Plug.Conn.put_req_header("referer", "https://bbc.co.uk/")
        |> Router.call([])

      assert {200, _, _} = sent_resp(conn)
    end

    test "invalid UTF8 path for the referer still allows outgoing request to work" do
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

      conn =
        conn(:get, "/fabl/xray")
        |> Plug.Conn.put_req_header("user-agent", "Mozilla/5.0")
        |> Plug.Conn.put_req_header("referer", "https://bbc.co.uk/%ED%95%B4%EC")
        |> Router.call([])

      assert {200, _, _} = sent_resp(conn)
    end

    test "User Agent containing invlid UTF8 characters still allows outgoing request to work" do
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

      conn =
        conn(:get, "/fabl/xray")
        |> Plug.Conn.put_req_header("user-agent", "Mozilla/fo%a0%B4%E")
        |> Plug.Conn.put_req_header("referer", "https://bbc.co.uk/%ED%95%B4%EC")
        |> Router.call([])

      assert {200, _, _} = sent_resp(conn)
    end
  end

  test "expected messages are sent to AWS X-Ray client" do
    start_supervised!({RouteState, "SomeRouteState"})
    set_env(:aws_ex_ray, :sampling_rate, 1.0)
    :erlang.trace(aws_ex_ray_udp_client_pid(), true, [:receive])

    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name, _role_arn, _payload, _opts ->
      {:ok, @lambda_response}
    end)

    conn(:get, "/200-ok-response")
    |> Router.call([])

    assert_receive {:trace, _, :receive, {_, _, {:send, webcore_service_subsegment}}}
    assert_receive {:trace, _, :receive, {_, _, {:send, invoke_lambda_service_subsegment}}}
    assert_receive {:trace, _, :receive, {_, _, {:send, segment}}}

    assert webcore_service_subsegment =~ ~s("type":"subsegment")
    assert webcore_service_subsegment =~ ~s("name":"webcore-service")

    assert invoke_lambda_service_subsegment =~ ~s("type":"subsegment")
    assert invoke_lambda_service_subsegment =~ ~s("name":"invoke-lambda-call")

    assert segment =~ ~s("name":"Belfrage")
  end

  defp aws_ex_ray_udp_client_pid() do
    with [{:aws_ex_ray_client_pool, poolboy_pid, :worker, [:poolboy]}] <-
           Supervisor.which_children(AwsExRay.Client.UDPClientSupervisor),
         {:state, _pid, [udp_client_pid], _, _, _, _, _, :lifo} <- :sys.get_state(poolboy_pid) do
      udp_client_pid
    end
  end
end
