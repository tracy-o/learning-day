defmodule Belfrage.Clients.LambdaTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.Lambda

  @credentials %Belfrage.AWS.Credentials{}

  describe "Belfrage.Clients.Lambda.call/3" do
    test "Given a working function name and payload it authenticates and calls the lambda and returns the response" do
      Belfrage.AWSMock
      |> expect(:request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:ok, "<h1>A Page</h1>"}
      end)

      assert Lambda.call(@credentials, "pwa-lambda-function", %{some: "data"}, "larry-the-lambda-request") ==
               {:ok, "<h1>A Page</h1>"}
    end

    test "Given an incorrect function name we return the :failed_to_invoke_lambda error" do
      Belfrage.AWSMock
      |> expect(:request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:error,
         {:http_error, 500,
          %{
            body: "{\"Message\":\"Some error was raised.\",\"Type\":\"User\"}"
          }}}
      end)

      assert Lambda.call(@credentials, "not-a-real-lambda", %{some: "data"}, "larry-the-lambda-request") ==
               {:error, :failed_to_invoke_lambda}
    end

    test "Given a correct function name and the lambda timesout we return the :failed_to_invoke_lambda error" do
      Belfrage.AWSMock
      |> expect(:request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:error, :timeout}
      end)

      assert Lambda.call(
               @credentials,
               "pwa-lambda-function:timeout",
               %{some: "data"},
               "larry-the-lambda-request"
             ) ==
               {:error, :failed_to_invoke_lambda}
    end

    test "Given a correct function name, but a non-existant alias we return the :function_not_found error" do
      Belfrage.AWSMock
      |> expect(:request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:error,
         {:http_error, 404,
          %{
            body:
              "{\"Message\":\"Function not found: arn:aws:lambda:eu-west-1:123456789:function:some-lambda-function\",\"Type\":\"User\"}"
          }}}
      end)

      assert Lambda.call(
               @credentials,
               "pwa-lambda-function:unknown-alias",
               %{some: "data"},
               "larry-the-lambda-request"
             ) ==
               {:error, :function_not_found}
    end
  end

  describe "Belfrage.Clients.Lambda.call/4" do
    test "Given a trace_id option, it invokes a lambda" do
      Belfrage.AWSMock
      |> expect(:request, fn %ExAws.Operation.JSON{
                               service: :lambda,
                               headers: [
                                 {"content-type", "application/json"},
                                 {"X-Amzn-Trace-Id", "1-xxxx-yyyyyyyyyyyyyyyy"}
                               ]
                             },
                             _opts ->
        {:ok, "<h1>trace_id option provided</h1>"}
      end)

      assert Lambda.call(@credentials, "pwa-lambda-function", %{some: "data"}, "larry-the-lambda-request",
               xray_trace_id: "1-xxxx-yyyyyyyyyyyyyyyy"
             ) ==
               {:ok, "<h1>trace_id option provided</h1>"}
    end
  end
end
