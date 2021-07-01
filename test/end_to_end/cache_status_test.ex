defmodule EndToEnd.ResponseHeaders.CacheStatusTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  @cacheable_lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  describe "when cache doesn't contain response" do
    test "returns the 'MISS' cache status header" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, @cacheable_lambda_response}
      end)

      response_conn = conn(:get, "/200-ok-response") |> Router.call([])

      assert {200, _resp_headers, _body} = sent_resp(response_conn)
      assert ["MISS"] = get_resp_header(response_conn, "belfrage-cache-status")
    end
  end

  describe "when cache contains the response" do
    test "returns the 'HIT' cache status header" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, 1, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, @cacheable_lambda_response}
      end)

      conn(:get, "/200-ok-response") |> Router.call([])
      response_conn = conn(:get, "/200-ok-response") |> Router.call([])

      assert {200, _resp_headers, _body} = sent_resp(response_conn)
      assert ["HIT"] = get_resp_header(response_conn, "belfrage-cache-status")
    end
  end
end
