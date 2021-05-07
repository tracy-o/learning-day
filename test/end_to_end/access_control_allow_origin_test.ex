defmodule AccessControlAllowOriginTest do
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
    :ok
  end

  test "when request is from the cdn" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name, _role_arn, _headers, _request_id, _opts ->
      {:ok, @lambda_response}
    end)

    conn =
      conn(:get, "/200-ok-response")
      |> put_req_header("x-bbc-edge-cdn", "1")

    conn = Router.call(conn, [])

    assert {200, headers, _response_body} = sent_resp(conn)
    assert {"access-control-allow-origin", "*"} in headers
  end

  test "when request is not from the cdn" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name, _role_arn, _headers, _request_id, _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response")

    conn = Router.call(conn, [])

    assert {200, headers, _response_body} = sent_resp(conn)
    refute {"access-control-allow-origin", "*"} in headers
  end
end
