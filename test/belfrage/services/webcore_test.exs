defmodule Belfrage.Services.WebcoreTest do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @arn Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)

  @graphql_struct StructHelper.build(
                    private: %{origin: "arn:aws:lambda:eu-west-1:123456:function:webcore-graphql"},
                    request: %{method: "GET", path: "/graphql?operationName=ContainersPromoGroup"}
                  )

  @graphql_lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from GraphQL!</h1>"
  }

  describe "GraphQL Webcore lambda service" do
    test "given a GraphQL path it invokes the Graphql lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore-graphql",
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
             } = Webcore.dispatch(@graphql_struct)
    end
  end

  @service_worker_struct StructHelper.build(
                           private: %{origin: "arn:aws:lambda:eu-west-1:123456:function:webcore-service-worker"},
                           request: %{method: "GET", path: "/service-worker.js"}
                         )

  @service_worker_lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from the Service Worker!</h1>"
  }

  describe "Service Worker Webcore lambda service" do
    test "given a Service Worker path it invokes the Service Worker lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore-service-worker",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/service-worker.js"
                                           } ->
        {:ok, @service_worker_lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from the Service Worker!</h1>"
               }
             } = Webcore.dispatch(@service_worker_struct)
    end
  end

  @pwa_struct StructHelper.build(
                private: %{origin: "arn:aws:lambda:eu-west-1:123456:function:webcore-pwa"},
                request: %{method: "GET", path: "/_web_core"}
              )

  @pwa_lambda_response %{
    "headers" => %{},
    "statusCode" => 200,
    "body" => "<h1>Hello from the Progressive Web App!</h1>"
  }

  describe "Progressive Web App Webcore lambda service" do
    test "given a Progressive Web App path it invokes the Progressive Web App lambda" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore-pwa",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core"
                                           } ->
        {:ok, @pwa_lambda_response}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from the Progressive Web App!</h1>"
               }
             } = Webcore.dispatch(@pwa_struct)
    end
  end

  @graphql_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, GraphQL broke"
  }

  @service_worker_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, the Service Worker broke"
  }

  @pwa_response_internal_fail %{
    "headers" => %{},
    "statusCode" => 500,
    "body" => "oh dear, the Progressive Web App broke"
  }

  describe "Failures from Webcore services" do
    test "GraphQL lambda is invoked, but GraphQL returns an error" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore-graphql",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/graphql?operationName=ContainersPromoGroup"
                                           } ->
        {:ok, @graphql_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, GraphQL broke"
               }
             } = Webcore.dispatch(@graphql_struct)
    end

    test "Service Worker lambda is invoked, but the Service Worker returns an error" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore-service-worker",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/service-worker.js"
                                           } ->
        {:ok, @service_worker_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, the Service Worker broke"
               }
             } = Webcore.dispatch(@service_worker_struct)
    end

    test "Progressive Web App lambda is invoked, but the Progressive Web App returns an error" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore-pwa",
                                           %{
                                             headers: %{country: nil},
                                             httpMethod: "GET",
                                             path: "/_web_core"
                                           } ->
        {:ok, @pwa_response_internal_fail}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "oh dear, the Progressive Web App broke"
               }
             } = Webcore.dispatch(@pwa_struct)
    end

    test "cannot invoke a lambda it serves a generic 500" do
      expect(Clients.LambdaMock, :call, fn @arn,
                                           "arn:aws:lambda:eu-west-1:123456:function:webcore-graphql",
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
             } = Webcore.dispatch(@graphql_struct)
    end
  end
end
