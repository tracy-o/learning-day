defmodule Belfrage.Services.ServiceWorkerLambdaTest do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore.ServiceWorker
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @struct StructHelper.build(
            private: %{origin: "https://www.bbc.co.uk/service-worker.js"},
            request: %{method: "GET", path: "/service-worker.js"}
          )

  @graphql_lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from Service Worker!</h1>"
  }

  @graphql_lambda_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, Service Worker broke"
  }

  @arn Application.fetch_env!(:belfrage, :service_worker_lambda_role_arn)
  @function Application.fetch_env!(:belfrage, :service_worker_lambda_function)

  describe "service worker lambda service" do
    test "given a path it invokes the lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           @function,
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/service-worker.js"
                                           } ->
        {:ok, @graphql_lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from Service Worker!</h1>"
               }
             } = ServiceWorker.dispatch(@struct)
    end

    test "lambda is invoked, but service worker returns an error" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           @function,
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/service-worker.js"
                                           } ->
        {:ok, @graphql_lambda_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, Service Worker broke"
               }
             } = ServiceWorker.dispatch(@struct)
    end

    test "cannot invoke the lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           @function,
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/service-worker.js"
                                           } ->
        {:error, :failed_to_invoke_lambda}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: ""
               }
             } = ServiceWorker.dispatch(@struct)
    end
  end
end
