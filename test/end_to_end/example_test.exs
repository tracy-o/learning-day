defmodule EndToEndTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()
  end

  test "a successful response from a lambda e2e" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:test",
                        %{
                          body: "",
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/weather",
                          pathParameters: %{},
                          queryStringParameters: %{}
                        } ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/weather")
    conn = Router.call(conn, [])

    assert {200,
            [
              {"cache-control", "public, stale-while-revalidate=0, max-age=30"},
              {"vary", "Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Scheme"},
              {"server", "Belfrage"}
            ], @lambda_response["body"]} == sent_resp(conn)
  end

  test "passes on query string parameters" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn,
                        _function_name,
                        %{
                          queryStringParameters: %{"query" => %{"hi" => "foo"}}
                        } ->
      {:ok, @lambda_response}
    end)

    conn(:get, "/wc-data/container/any-container?query[hi]=foo") |> Router.call([])
  end

  test "a failed response from a lambda e2e" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _function_name, _payload ->
      response =
        @lambda_response
        |> Map.put("statusCode", 500)

      {:ok, response}
    end)

    conn = conn(:get, "/weather")
    conn = Router.call(conn, [])

    assert {500,
            [
              {"cache-control", "public, stale-while-revalidate=0, max-age=30"},
              {"vary", "Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Scheme"},
              {"server", "Belfrage"}
            ], @lambda_response["body"]} == sent_resp(conn)
  end
end
