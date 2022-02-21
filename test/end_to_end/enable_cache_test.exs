defmodule EndToEnd.ResponseHeaders.EnableCacheTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  setup do
    :ets.delete_all_objects(:cache)
    start_supervised!({RouteState, "CacheDisabled"})
    :ok
  end

  @cacheable_lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  describe "when caching is disabled in the routespec" do
    test "the response isn't stored in the cache" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, 1, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, @cacheable_lambda_response}
      end)

      expect(Belfrage.Clients.CCPMock, :put, 0, fn _struct -> flunk("Should never be called.") end)

      conn(:get, "/caching-disabled") |> Router.call([])
    end

    test "the cache is never checked for a response" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, 1, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, @cacheable_lambda_response}
      end)

      expect(Belfrage.Clients.CCPMock, :fetch, 0, fn _struct -> flunk("Should never be called.") end)

      conn(:get, "/caching-disabled") |> Router.call([])
    end

    test "returns a miss from cache" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, 2, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, @cacheable_lambda_response}
      end)

      conn(:get, "/caching-disabled") |> Router.call([])

      response_conn = conn(:get, "/caching-disabled") |> Router.call([])

      assert {200, _resp_headers, _body} = sent_resp(response_conn)
      assert ["MISS"] = get_resp_header(response_conn, "belfrage-cache-status")
      assert ["CacheDisabled"] == get_resp_header(response_conn, "routespec")

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=30"] ==
               get_resp_header(response_conn, "cache-control")
    end
  end
end
