defmodule NonUtf8QueryStringTest do
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

  # Is this test failing for you? It was fixed in Crimpex 0.1.1, try deleting your deps folder and running mix deps.get
  test "Given a query string with non utf8 characters, it still passes this on to the origin" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:test",
                        %{
                          body: "",
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => "�"}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?query=%B3")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Given a query string with accented characters and spaces, it still passes this on to the origin" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:test",
                        %{
                          body: "",
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => "science café"}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?query=science%20caf%C3%A9")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Given a query string with a multi byte character, it still passes this on to the origin" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        "pwa-lambda-function:test",
                        %{
                          body: "",
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => "€100"}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?query=%E2%82%AC100")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end
end
