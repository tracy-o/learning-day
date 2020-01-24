defmodule Belfrage.Services.WebcoreTest do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Belfrage.Struct

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @arn Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)

  @struct %Struct{
    private: %Struct.Private{origin: "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function"},
    request: %Struct.Request{
      method: "GET",
      path: "/_web_core",
      query_params: %{"id" => "1234"},
      xray_trace_id: "1-xxxxx-yyyyyyyyyyyyyyy"
    }
  }

  @lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  describe "Webcore lambda service" do
    test "given a struct it invokes the origin lambda" do
      expect(Clients.LambdaMock, :call, fn _role_arn = @arn,
                                           _lambda_func = "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           _payload = %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           },
                                           _opts ->
        {:ok, @lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from the Lambda!</h1>"
               }
             } = Webcore.dispatch(@struct)
    end

    test "it invokes the origin lambda with the xray_trace_id" do
      expect(Clients.LambdaMock, :call, fn _role_arn,
                                           _func_name,
                                           _payload,
                                           _opts = [xray_trace_id: "1-xxxxx-yyyyyyyyyyyyyyy"] ->
        {:ok, @lambda_response}
      end)

      Webcore.dispatch(@struct)
    end

    test "given an origin with an alias, it invokes the origin lambda with that alias" do
      expect(Clients.LambdaMock, :call, fn _role_arn = @arn,
                                           _lambda_func =
                                             "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function:example-branch",
                                           _payload = %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           },
                                           _opts ->
        {:ok, @lambda_response}
      end)

      struct = %{
        @struct
        | private: %{origin: "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function:example-branch"}
      }

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from the Lambda!</h1>"
               }
             } = Webcore.dispatch(struct)
    end

    test "it will invoke lambda with the accept-encoding header" do
      expect(Clients.LambdaMock, :call, fn _lambda_role_arn,
                                           _lambda_function_name,
                                           %{
                                             headers: %{"accept-encoding": "gzip"}
                                           } ->
        {:ok, @lambda_response}
      end)

      Webcore.dispatch(@struct)
    end
  end

  @lambda_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, Lambda broke"
  }

  describe "Failures from Webcore services" do
    test "The origin Lambda is invoked, but it returns an error" do
      expect(Clients.LambdaMock, :call, fn _role_arn = @arn,
                                           _lambda_func = "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           _payload = %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           },
                                           _opts ->
        {:ok, @lambda_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, Lambda broke"
               }
             } = Webcore.dispatch(@struct)
    end

    test "cannot invoke a lambda it serves a generic 500" do
      expect(Clients.LambdaMock, :call, fn _role_arn = @arn,
                                           _lambda_func = "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           _payload = %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           },
                                           _opts ->
        {:error, :failed_to_invoke_lambda}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: ""
               }
             } = Webcore.dispatch(@struct)
    end

    test "When the alias cannot be found, we serve a 404" do
      expect(Clients.LambdaMock, :call, fn _role_arn = @arn,
                                           _lambda_func = "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           _payload = %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           },
                                           _opts ->
        {:error, :function_not_found}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 404,
                 body: "404 - not found"
               }
             } = Webcore.dispatch(@struct)
    end

    test "When the client times out" do
      expect(Clients.LambdaMock, :call, fn _role_arn = @arn,
                                           _lambda_func = "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           _payload = %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           },
                                           _opts ->
        {:error, :timeout}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: ""
               }
             } = Webcore.dispatch(@struct)
    end
  end
end
