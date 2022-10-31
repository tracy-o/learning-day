defmodule EndToEnd.CacheBustTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [build_request_uri: 1]

  @moduletag :end_to_end

  @cacheable_lambda_response %{
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

  test "only fetches from origin once when no cache bust override is set" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, 1, fn _role_arn, _lambda_function, _payload, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn(:get, build_request_uri(path: "/200-ok-response")) |> Router.call([])
    conn(:get, build_request_uri(path: "/200-ok-response")) |> Router.call([])
    conn(:get, build_request_uri(path: "/200-ok-response")) |> Router.call([])
  end

  test "always calls the origin when the cache bust override is set" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, 3, fn _role_arn, _lambda_function, _payload, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn(:get, build_request_uri(path: "/200-ok-response", query: "belfrage-cache-bust")) |> Router.call([])
    conn(:get, build_request_uri(path: "/200-ok-response", query: "belfrage-cache-bust")) |> Router.call([])
    conn(:get, build_request_uri(path: "/200-ok-response", query: "belfrage-cache-bust")) |> Router.call([])
  end

  test "request hash is in cache bust format when cache bust override is set" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _lambda_function, _payload, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn = conn(:get, build_request_uri(path: "/200-ok-response", query: "belfrage-cache-bust")) |> Router.call([])

    assert [request_hash] = get_resp_header(conn, "bsig")
    assert String.starts_with?(request_hash, "cache-bust.")
  end
end
