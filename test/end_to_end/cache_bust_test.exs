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
    |> expect(:call, 1, fn _role_arn, _lambda_function, _payload, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn(:get, "/weather") |> Router.call([])
    conn(:get, "/weather") |> Router.call([])
    conn(:get, "/weather") |> Router.call([])
  end

  test "always calls the origin when the cache bust override is set" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, 3, fn _role_arn, _lambda_function, _payload, _opts ->
      {:ok, @cacheable_lambda_response}
    end)

    conn(:get, "/weather?belfrage-cache-bust") |> Router.call([])
    conn(:get, "/weather?belfrage-cache-bust") |> Router.call([])
    conn(:get, "/weather?belfrage-cache-bust") |> Router.call([])
  end
end
