defmodule IsUKTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
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
    start_supervised!({RouteState, "SomeRouteState"})
    :ok
  end

  test "edge is_uk headers set to no" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name,
                        _role_arn,
                        %{
                          headers: %{is_uk: false}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn =
      conn(:get, "/200-ok-response")
      |> put_req_header("x-bbc-edge-isuk", "no")
      |> put_req_header("x-bbc-edge-cache", "1")

    conn = Router.call(conn, [])

    assert {200, _headers, _response_body} = sent_resp(conn)
  end

  test "edge is_uk headers set to yes" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name,
                        _role_arn,
                        %{
                          headers: %{is_uk: true}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn =
      conn(:get, "/200-ok-response")
      |> put_req_header("x-bbc-edge-isuk", "yes")
      |> put_req_header("x-bbc-edge-cache", "1")

    conn = Router.call(conn, [])

    assert {200, _headers, _response_body} = sent_resp(conn)
  end

  test "is_uk headers set to no" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name,
                        _role_arn,
                        %{
                          headers: %{is_uk: false}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn =
      conn(:get, "/200-ok-response")
      |> put_req_header("x-ip_is_uk_combined", "no")

    conn = Router.call(conn, [])

    assert {200, _headers, _response_body} = sent_resp(conn)
  end

  test "is_uk headers set to yes" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name,
                        _role_arn,
                        %{
                          headers: %{is_uk: true}
                        },
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn =
      conn(:get, "/200-ok-response")
      |> put_req_header("x-ip_is_uk_combined", "yes")

    conn = Router.call(conn, [])

    assert {200, _headers, _response_body} = sent_resp(conn)
  end
end
