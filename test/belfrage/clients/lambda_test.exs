defmodule Belfrage.Clients.LambdaTest do
  alias Belfrage.Clients.Lambda
  use ExUnit.Case
  use Test.Support.Helper, :mox
  @lambda_timeout Application.get_env(:belfrage, :lambda_timeout)

  describe "Belfrage.Clients.Lambda.call/3" do
    test "Given a working function name, role arn, and payload it authenticates and calls the lambda and returns the response" do
      assert Lambda.call("webcore-lambda-role-arn", "pwa-lambda-function", %{some: "data"}) ==
               {:ok, "<h1>A Page</h1>"}
    end

    test "Given a role we cannot assume we return the :failed_to_assume_role error" do
      assert Lambda.call("the-wrong-role", "pwa-lambda-function", %{some: "data"}) ==
               {:error, :credentials_not_found}
    end

    test "Given a working role, but an incorrect function name we return the :failed_to_invoke_lambda error" do
      :timer.sleep(1100)

      assert Lambda.call("webcore-lambda-role-arn", "not-a-real-lambda", %{some: "data"}) ==
               {:error, :failed_to_invoke_lambda}
    end

    test "Given a working role, a correct function name and the lambda timesout we return the :failed_to_invoke_lambda error" do
      assert Lambda.call("webcore-lambda-role-arn", "pwa-lambda-function:timeout", %{some: "data"}) ==
               {:error, :failed_to_invoke_lambda}
    end

    test "Given a working role, a correct function name, but a non-existant alias we return the :function_not_found error" do
      assert Lambda.call("webcore-lambda-role-arn", "pwa-lambda-function:unknown-alias", %{some: "data"}) ==
               {:error, :function_not_found}
    end
  end

  describe "ExAWS request callback" do
    @generic_response {:ok,
                       %Belfrage.Clients.HTTP.Response{
                         status_code: 200,
                         headers: [{"content-type", "application/json"}],
                         body: "{}"
                       }}

    test "Lambda request function uses http client to send POST" do
      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                               method: :post,
                               url: "https://www.example.com/foo",
                               payload: ~s({"some": "data"}),
                               headers: %{},
                               timeout: @lambda_timeout
                             } ->
        @generic_response
      end)

      Lambda.request(:post, "https://www.example.com/foo", ~s({"some": "data"}))
    end

    test "Lambda request function does pass through query strings" do
      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                               method: :post,
                               url: "https://www.example.com/foo?some-qs=hello",
                               payload: ~s({"some": "data"}),
                               headers: %{},
                               timeout: @lambda_timeout
                             } ->
        @generic_response
      end)

      Lambda.request(:post, "https://www.example.com/foo?some-qs=hello", ~s({"some": "data"}))
    end

    test "Lambda request handles get" do
      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                               method: :get,
                               url: "https://www.example.com/foo?some-qs=hello",
                               payload: "",
                               headers: %{},
                               timeout: @lambda_timeout
                             } ->
        @generic_response
      end)

      Lambda.request(:get, "https://www.example.com/foo?some-qs=hello")
    end
  end
end
