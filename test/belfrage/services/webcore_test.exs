defmodule Belfrage.Services.WebcoreTest do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @struct StructHelper.build(
            private: %{origin: "arn:aws:lambda:eu-west-1:123456:function:webcore"},
            request: %{method: "GET", path: "/graphql?operationName=ContainersPromoGroup"}
          )

  @webcore_lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from GraphQL!</h1>"
  }

  @webcore_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, GraphQL broke"
  }

  @arn Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)

  describe "graphql lambda service" do
    test "given a path it invokes the lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/graphql?operationName=ContainersPromoGroup"
                                           } ->
        {:ok, @webcore_lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from GraphQL!</h1>"
               }
             } = Webcore.dispatch(@struct)
    end

    test "lambda is invoked, but graphql returns an error" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/graphql?operationName=ContainersPromoGroup"
                                           } ->
        {:ok, @webcore_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, GraphQL broke"
               }
             } = Webcore.dispatch(@struct)
    end

    test "cannot invoke the lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/graphql?operationName=ContainersPromoGroup"
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
