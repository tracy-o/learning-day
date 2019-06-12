defmodule Ingress.Services.LambdaTest do
  alias Ingress.{Clients, Struct}
  alias Ingress.Services.Lambda
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @struct StructHelper.build(
            private: %{origin: "https://www.bbc.co.uk"},
            request: %{payload: ~s({"some": "data"}), method: "POST"}
          )

  @web_core_lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from Lambda!</h1>"
  }

  @web_core_lambda_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, presentation layer broke"
  }

  describe "web core lambda service" do
    test "given a path it invokes the lambda" do
      expect(Clients.LambdaMock, :call, fn "ec2-role",
                                           "webcore-lambda-role-arn",
                                           "webcore-lambda-name-progressive-web-app",
                                           %{
                                             body: ~s({"some": "data"}),
                                             headers: %{country: nil},
                                             httpMethod: "POST",
                                             path: "/_web_core"
                                           } ->
        {:ok, @web_core_lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from Lambda!</h1>"
               }
             } = Lambda.dispatch(@struct)
    end

    test "lambda is invoked, but web core says its an error" do
      expect(Clients.LambdaMock, :call, fn "ec2-role",
                                           "webcore-lambda-role-arn",
                                           "webcore-lambda-name-progressive-web-app",
                                           %{
                                             body: ~s({"some": "data"}),
                                             headers: %{country: nil},
                                             httpMethod: "POST",
                                             path: "/_web_core"
                                           } ->
        {:ok, @web_core_lambda_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, presentation layer broke"
               }
             } = Lambda.dispatch(@struct)
    end

    test "cannot invoke the lambda" do
      expect(Clients.LambdaMock, :call, fn "ec2-role",
                                           "webcore-lambda-role-arn",
                                           "webcore-lambda-name-progressive-web-app",
                                           %{
                                             body: ~s({"some": "data"}),
                                             headers: %{country: nil},
                                             httpMethod: "POST",
                                             path: "/_web_core"
                                           } ->
        {:error, :failed_to_invoke_lambda}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: ""
               }
             } = Lambda.dispatch(@struct)
    end
  end
end
