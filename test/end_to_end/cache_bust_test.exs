defmodule EndToEnd.CacheBustTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

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

    :ok
  end

  test "only fetches from origin once when no cache bust override is set" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, 1, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn(:get, "/200-ok-response") |> Router.call([])
    conn(:get, "/200-ok-response") |> Router.call([])
    conn(:get, "/200-ok-response") |> Router.call([])
  end

  test "always calls the origin when the cache bust override is set" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, 3, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn(:get, "/200-ok-response?belfrage-cache-bust") |> Router.call([])
    conn(:get, "/200-ok-response?belfrage-cache-bust") |> Router.call([])
    conn(:get, "/200-ok-response?belfrage-cache-bust") |> Router.call([])
  end

  test "request hash is in cache bust format when cache bust override is set" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?belfrage-cache-bust") |> Router.call([])

    assert [request_hash] = get_resp_header(conn, "bsig")
    assert String.starts_with?(request_hash, "cache-bust.")
  end
end
