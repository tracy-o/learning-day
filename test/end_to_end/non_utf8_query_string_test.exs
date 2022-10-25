defmodule NonUtf8QueryStringTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  alias Belfrage.Clients.{HTTP, HTTPMock, LambdaMock}
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [build_https_request_uri: 1]

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
    :ok
  end

  test "Given a query string with accented characters and spaces, it still passes this on to the origin" do
    start_supervised!({RouteState, "SomeRouteState"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_function_name,
                        %{
                          body: nil,
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => "science café"}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, build_https_request_uri("/200-ok-response?query=science%20caf%C3%A9"))
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Given a query string with a multi byte character, it still passes this on to the origin" do
    start_supervised!({RouteState, "SomeRouteState"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_function_name,
                        %{
                          body: nil,
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => "€100"}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, build_https_request_uri("/200-ok-response?query=%E2%82%AC100"))
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Given a query string with no value, it still passes this on to the origin" do
    start_supervised!({RouteState, "SomeRouteState"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_function_name,
                        %{
                          body: nil,
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => ""}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, build_https_request_uri("/200-ok-response?query"))
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "query string with invalid utf characters results in a 200" do
    start_supervised!({RouteState, "SomeRouteState"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_function_name,
                        %{
                          body: nil,
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => <<246>>}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn =
      :get
      |> conn(build_https_request_uri("/200-ok-response?query=%f6"))
      |> Router.call([])

    {status, _headers, _body} = sent_resp(conn)
    assert status == 200
  end

  test "path params with invalid utf chars result in 500 for requests to WebCore" do
    start_supervised!({RouteState, "SomeRouteState"})

    conn = conn(:get, build_https_request_uri("/format/rewrite/fo%a0"))

    # Actually call ExAws to trigger the error on JSON-encoding the lambda
    # payload
    stub(LambdaMock, :call, fn _arn, function, payload, opts ->
      function
      |> Belfrage.AWS.Lambda.invoke(payload, %{}, opts)
      |> Belfrage.AWS.request(
        security_token: "some_token",
        access_key_id: "some_access_key_id",
        secret_access_key: "some_access_key"
      )
    end)

    # TODO the invalid string is actually causing the logger to fail (because the string is not a valid string!)
    assert_raise Plug.Conn.WrapperError, "** (ErlangError) Erlang error: {:invalid_string, <<102, 111, 160>>}", fn ->
      Router.call(conn, [])
    end

    {status, _headers, _body} = sent_resp(conn)
    assert status == 500
  end

  test "path params with invalid utf chars don't raise an error for non-Webcore requests" do
    start_supervised!({RouteState, "SomeFablRouteState"})

    fabl_url = URI.decode("#{Application.get_env(:belfrage, :fabl_endpoint)}/module/fo%a0")

    expect(HTTPMock, :execute, fn %HTTP.Request{url: ^fabl_url}, :Fabl ->
      {:ok, %HTTP.Response{status_code: 200, body: "OK"}}
    end)

    conn = conn(:get, build_https_request_uri("/fabl/fo%a0")) |> Router.call([])
    assert conn.status == 200
  end

  test "malformed URI" do
    start_supervised!({RouteState, "SomeRouteState"})

    LambdaMock
    |> expect(:call, fn _credentials,
                        _lambda_function_name,
                        %{
                          body: nil,
                          headers: %{country: "gb"},
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{"query" => <<37, 224, 37, 37>>}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn =
      :get
      |> conn(build_https_request_uri("/200-ok-response?query=%%E0%%"))
      |> Router.call([])

    {status, _headers, _body} = sent_resp(conn)
    assert status == 200
  end
end
