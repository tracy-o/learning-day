defmodule EndToEnd.XrayTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.Clients.HTTP

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
    Belfrage.LoopsSupervisor.kill_all()
  end

  describe "hitting the webcore lambda" do
    test "when start_trace/1 errors, requests still succeed" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _lambda_name, _role_arn, _payload, _request_id, _opts ->
        {:ok, @lambda_response}
      end)

      Belfrage.XrayMock
      |> expect(:start_tracing, fn "Belfrage" ->
        {:error, %RuntimeError{message: "<AwsExRay> Tracing Context already exists on this process."}}
      end)

      conn(:get, "/200-ok-response")
      |> Router.call([])
    end
  end

  describe "hitting the fabl endpoint" do
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

    test "when start_trace/1 errors, fabl headers don't contain x-amzn-trace-id" do
      Belfrage.XrayMock
      |> expect(:start_tracing, fn "Belfrage" ->
        {:error, %RuntimeError{message: "<AwsExRay> Tracing Context already exists on this process."}}
      end)

      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn %HTTP.Request{headers: headers}, :Fabl ->
        refute Map.has_key?(headers, "x-amzn-trace-id")

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
