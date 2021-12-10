defmodule BelfrageWeb.ResponseHeaders.RouteSpecHeaderTest do
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

  test "returns the routespec header" do
    Belfrage.Clients.LambdaMock
    |> stub(:call, fn _lambda_name, _role_arn, _payload, _request_id, _opts ->
      {:ok, @lambda_response}
    end)

    response_conn = conn(:get, "/200-ok-response") |> Router.call([])

    assert {200, _resp_headers, _body} = sent_resp(response_conn)

    assert ["SomeLoop"] = get_resp_header(response_conn, "routespec")
  end
end
