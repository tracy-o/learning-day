defmodule BelfrageTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.LambdaMock
  alias Test.Support.StructHelper

  @get_request_struct StructHelper.build(
                        private: %{
                          loop_id: "SportVideos"
                        },
                        request: %{
                          path: "/_web_core",
                          method: "GET",
                          country: "gb"
                        }
                      )

  @post_request_struct StructHelper.build(
                         request: %{
                           method: "POST",
                           payload: ~s({"some": "data please"}),
                           country: "gb"
                         },
                         private: %{
                           loop_id: "SportVideos"
                         }
                       )

  @web_core_lambda_response {:ok, %{"body" => "Some content", "headers" => %{}, "statusCode" => 200}}
  @web_core_404_lambda_response {:ok, %{"body" => "404 - not found", "headers" => %{}, "statusCode" => 404}}

  test "GET request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:test",
                        %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"} ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@get_request_struct)
  end

  test "GET request on a subdomain, invokes lambda with the lambda alias" do
    struct = Belfrage.Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})

    LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:example-branch",
                        %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"} ->
      @web_core_lambda_response
    end)

    Belfrage.handle(struct)
  end

  test "GET request on a subdomain with no matching alias, invokes lambda with the lambda alias and returns the 404 response" do
    struct = Belfrage.Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})

    LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:example-branch",
                        %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"} ->
      @web_core_404_lambda_response
    end)

    thing = Belfrage.handle(struct)

    assert thing.response.http_status == 404
    assert thing.response.body == "404 - not found"
  end

  test "POST request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:test",
                        %{
                          body: ~s({"some": "data please"}),
                          headers: %{country: "gb"},
                          httpMethod: "POST"
                        } ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@post_request_struct)
  end
end
