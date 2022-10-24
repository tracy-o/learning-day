defmodule BelfrageWeb.ResponseHeaders.PipelineTrailHeaderTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
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

  test "returns the pipeline trail header" do
    start_supervised!({RouteState, "SomeRouteState"})

    Belfrage.Clients.LambdaMock
    |> stub(:call, fn _lambda_name, _role_arn, _payload, _opts ->
      {:ok, @lambda_response}
    end)

    response_conn = conn(:get, build_https_request_uri("/200-ok-response")) |> Router.call([])

    assert {200, _resp_headers, _body} = sent_resp(response_conn)

    assert get_resp_header(response_conn, "belfrage-request-pipeline-trail")
  end
end
