defmodule Belfrage.Services.WebcoreTest do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @arn Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)

  @struct StructHelper.build(
            private: %{origin: "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function"},
            request: %{
              method: "GET",
              path: "/_web_core",
              query_params: %{"id" => "1234"}
            }
          )

  @lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  describe "Webcore lambda service" do
    test "given a struct it invokes the origin lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           } ->
        {:ok, @lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from the Lambda!</h1>"
               }
             } = Webcore.dispatch(@struct)
    end

    test "given an origin with an alias, it invokes the origin lambda with that alias" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function:example-branch",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           } ->
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
  end

  @lambda_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, Lambda broke"
  }

  describe "Failures from Webcore services" do
    test "The origin Lambda is invoked, but it returns an error" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           } ->
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
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core",
                                             queryStringParameters: %{"id" => "1234"}
                                           } ->
        {:error, :failed_to_invoke_lambda}
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
