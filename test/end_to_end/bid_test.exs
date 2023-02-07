defmodule BelfrageWeb.ResponseHeaders.BIDTest do
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
    start_supervised!({RouteState, "SomeRouteState.Webcore"})
    :ok
  end

  test "returns the bid header" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name, _role_arn, _payload, _opts ->
      {:ok, @lambda_response}
    end)

    response_conn = conn(:get, "/200-ok-response") |> Router.call([])

    assert {200, resp_headers, _body} = sent_resp(response_conn)
    assert {"bid", Application.get_env(:belfrage, :stack_id)} in resp_headers
  end
end
