defmodule Belfrage.Clients.LambdaTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Test.Support.Helper, only: [set_env: 2, set_env: 3]

  alias Belfrage.Clients.Lambda
  alias Belfrage.Clients.{HTTP, HTTPMock}

  @credentials %Belfrage.AWS.Credentials{
    access_key_id: "test",
    secret_access_key: "test",
    session_token: "test"
  }

  describe "Belfrage.Clients.Lambda.call/3" do
    test "Given a working function name and payload it authenticates and calls the lambda and returns the response" do
      expect(Belfrage.AWSMock, :request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:ok, "<h1>A Page</h1>"}
      end)

      assert Lambda.call(@credentials, "pwa-lambda-function", %{some: "data"}) ==
               {:ok, "<h1>A Page</h1>"}
    end

    test "Given an incorrect function name we return the :invoke_failure error" do
      expect(Belfrage.AWSMock, :request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:error,
         {:http_error, 500,
          %{
            body: "{\"Message\":\"Some error was raised.\",\"Type\":\"User\"}"
          }}}
      end)

      assert Lambda.call(@credentials, "not-a-real-lambda", %{some: "data"}) ==
               {:error, :invoke_failure}
    end

    test "Given a correct function name and the lambda timesout we return the :invoke_timeout error" do
      expect(Belfrage.AWSMock, :request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:error, :timeout}
      end)

      assert Lambda.call(@credentials, "pwa-lambda-function:timeout", %{some: "data"}) == {:error, :invoke_timeout}
    end

    test "Given a correct function name, but a non-existant alias we return the :function_not_found error" do
      expect(Belfrage.AWSMock, :request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
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
               %{some: "data"}
             ) ==
               {:error, :function_not_found}
    end

    test "Given an aws_unhandled error we return the :invoke_failure error" do
      expect(Belfrage.AWSMock, :request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:error, {:aws_unhandled, "AWSError", "message", "err"}}
      end)

      assert Lambda.call(@credentials, "pwa-lambda-function:aws_unhandled", %{some: "data"}) ==
               {:error, :invoke_failure}
    end

    test "Given an unexpected sequence token we return the :invoke_failure error" do
      expect(Belfrage.AWSMock, :request, fn %ExAws.Operation.JSON{service: :lambda}, _opts ->
        {:error, {"AWSError", "message", "someUnexpectedToken"}}
      end)

      assert Lambda.call(@credentials, "pwa-lambda-function:unexpected_sequence", %{some: "data"}) ==
               {:error, :invoke_failure}
    end
  end

  describe "retries" do
    setup do
      # the default value for :max_attempts is 1 - as specified in config.exs
      set_env(:ex_aws, :retries, max_attempts: 2, base_backoff_in_ms: 10, max_backoff_in_ms: 200)
      set_env(:lambda_client, Belfrage.Clients.Lambda)
      set_env(:aws, Belfrage.AWS)
    end

    test "do not occur when a successful response is returned" do
      expect(HTTPMock, :execute, fn %HTTP.Request{}, _ ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"Message\":\"some message\"}"
         }}
      end)

      Lambda.call(@credentials, "pwa-lambda-function", %{some: "data"})
    end

    test "occur when a ThrottlingException response is returned" do
      expect(HTTPMock, :execute, fn %HTTP.Request{}, _ ->
        {:ok,
         %HTTP.Response{
           status_code: 400,
           body: "{\"Message\":\"some message\",\"__type\":\"ThrottlingException\"}"
         }}
      end)

      expect(HTTPMock, :execute, fn %HTTP.Request{}, _ ->
        {:ok,
         %HTTP.Response{
           status_code: 400,
           body: "{\"Message\":\"some message\",\"__type\":\"ThrottlingException\"}"
         }}
      end)

      Lambda.call(@credentials, "pwa-lambda-function", %{some: "data"})
    end

    test "occur when a ProvisionedThroughputExceededException response is returned" do
      expect(HTTPMock, :execute, fn %HTTP.Request{}, _ ->
        {:ok,
         %HTTP.Response{
           status_code: 400,
           body: "{\"Message\":\"some message\",\"__type\":\"ProvisionedThroughputExceededException\"}"
         }}
      end)

      expect(HTTPMock, :execute, fn %HTTP.Request{}, _ ->
        {:ok,
         %HTTP.Response{
           status_code: 400,
           body: "{\"Message\":\"some message\",\"__type\":\"ProvisionedThroughputExceededException\"}"
         }}
      end)

      Lambda.call(@credentials, "pwa-lambda-function", %{some: "data"})
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

      assert Lambda.call(@credentials, "pwa-lambda-function", %{some: "data"}, xray_trace_id: "1-xxxx-yyyyyyyyyyyyyyyy") ==
               {:ok, "<h1>trace_id option provided</h1>"}
    end
  end
end
