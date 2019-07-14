defmodule Belfrage.Services.GraphqlLambdaTest do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore.Graphql
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @struct StructHelper.build(
            private: %{origin: "https://www.bbc.co.uk/graphql?operationName=ContainersPromoGroup"},
            request: %{method: "GET", path: "/graphql?operationName=ContainersPromoGroup"}
          )

  @graphql_lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from GraphQL!</h1>"
  }

  @graphql_lambda_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, GraphQL broke"
  }

  @arn Application.fetch_env!(:belfrage, :graphql_lambda_role_arn)
  @function Application.fetch_env!(:belfrage, :graphql_lambda_function)

  describe "graphql lambda service" do
    test "given a path it invokes the lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           @function,
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/graphql?operationName=ContainersPromoGroup"
                                           } ->
        {:ok, @graphql_lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from GraphQL!</h1>"
               }
             } = Graphql.dispatch(@struct)
    end

    test "lambda is invoked, but graphql returns an error" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           @function,
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/graphql?operationName=ContainersPromoGroup"
                                           } ->
        {:ok, @graphql_lambda_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, GraphQL broke"
               }
             } = Graphql.dispatch(@struct)
    end

    test "cannot invoke the lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           @function,
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
             } = Graphql.dispatch(@struct)
    end
  end
end
