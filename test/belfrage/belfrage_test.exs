defmodule BelfrageTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [assert_gzipped: 2]

  alias Belfrage.Clients.LambdaMock
  alias Belfrage.Struct

  @get_request_struct %Struct{
    private: %Struct.Private{
      loop_id: "SportVideos",
      production_environment: "test"
    },
    request: %Struct.Request{
      path: "/_web_core",
      method: "GET",
      country: "gb"
    }
  }

  @post_request_struct %Struct{
    request: %Struct.Request{
      method: "POST",
      payload: ~s({"some": "data please"}),
      country: "gb"
    },
    private: %Struct.Private{
      loop_id: "SportVideos",
      production_environment: "test"
    }
  }

  @web_core_lambda_response {:ok, %{"body" => "Some content", "headers" => %{}, "statusCode" => 200}}
  @web_core_404_lambda_response {:ok, %{"body" => "404 - not found", "headers" => %{}, "statusCode" => 404}}

  test "GET request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "pwa-lambda-function:test",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@get_request_struct)
  end

  test "GET request on a subdomain, invokes lambda with the lambda alias" do
    struct = Belfrage.Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})

    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "preview-pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(struct)
  end

  test "GET request on a subdomain with no matching alias, invokes lambda with the lambda alias and returns the 404 response" do
    struct = Belfrage.Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})

    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "preview-pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _opts = [] ->
      @web_core_404_lambda_response
    end)

    thing = Belfrage.handle(struct)

    assert thing.response.http_status == 404
    assert_gzipped(thing.response.body, "404 - not found")
  end

  test "POST request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "pwa-lambda-function:test",
                        _payload = %{
                          body: ~s({"some": "data please"}),
                          headers: %{country: "gb"},
                          httpMethod: "POST"
                        },
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@post_request_struct)
  end

  @redirect_request_struct %Struct{
    private: %Struct.Private{
      loop_id: "SportVideos"
    },
    request: %Struct.Request{
      path: "/_web_core",
      method: "GET",
      country: "gb",
      host: "www.bbc.com",
      scheme: :http
    }
  }

  test "A HTTP request redirects to https, and doesn't call the lambda" do
    LambdaMock
    |> expect(:call, 0, fn _role_arn, _func_name, _payload, _opts -> :this_should_not_be_called end)

    response_struct = Belfrage.handle(@redirect_request_struct)

    assert response_struct.response.http_status == 302
  end
end
