defmodule NonUtf8QueryStringTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock, LambdaMock}
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

  test "Given a query string with accented characters and spaces, it still passes this on to the origin" do
    LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        _lambda_function_name,
                        %{
                          body: "",
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => "science café"}
                        },
                        _request_id,
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?query=science%20caf%C3%A9")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Given a query string with a multi byte character, it still passes this on to the origin" do
    LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        _lambda_function_name,
                        %{
                          body: "",
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => "€100"}
                        },
                        _request_id,
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?query=%E2%82%AC100")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Given a query string with no value, it still passes this on to the origin" do
    LambdaMock
    |> expect(:call, fn "webcore-lambda-role-arn",
                        _lambda_function_name,
                        %{
                          body: "",
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => ""}
                        },
                        _request_id,
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?query")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "query string with invalid utf characters results in a 404" do
    conn = conn(:get, "/200-ok-response?query=%f6")

    assert_raise Plug.Conn.InvalidQueryError, fn -> Router.call(conn, []) end

    {status, _headers, _body} = sent_resp(conn)
    assert status == 404
  end

  test "path params with invalid utf chars result in 500 for requests to WebCore" do
    conn = conn(:get, "/format/rewrite/fo%a0")

    # Actually call ExAws to trigger the error on JSON-encoding the lambda
    # payload
    stub(LambdaMock, :call, fn _arn, function, payload, _request_id, opts ->
      function
      |> Belfrage.AWS.Lambda.invoke(payload, %{}, opts)
      |> Belfrage.AWS.request(
        security_token: "some_token",
        access_key_id: "some_access_key_id",
        secret_access_key: "some_access_key"
      )
    end)

    assert_raise Plug.Conn.WrapperError, "** (ErlangError) Erlang error: {:invalid_string, <<102, 111, 160>>}", fn ->
      Router.call(conn, [])
    end

    {status, _headers, _body} = sent_resp(conn)
    assert status == 500
  end

  test "path params with invalid utf chars don't raise an error for non-Webcore requests" do
    fabl_url = URI.decode("#{Application.get_env(:belfrage, :fabl_endpoint)}/module/fo%a0")

    expect(HTTPMock, :execute, fn %HTTP.Request{url: ^fabl_url}, :Fabl ->
      {:ok, %HTTP.Response{status_code: 200, body: "OK"}}
    end)

    conn = conn(:get, "/fabl/fo%a0") |> Router.call([])
    assert conn.status == 200
  end
end
