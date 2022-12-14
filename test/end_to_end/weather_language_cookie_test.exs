defmodule EndToEnd.WeatherLanguageCookieTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.RequestTransformers.WeatherLanguageCookie
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  import Belfrage.Test.CachingHelper, only: [clear_cache: 0]

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
    },
    "statusCode" => 301,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  setup do
    start_supervised!({RouteState, "SomeRouteState"})
    clear_cache()
    :ok
  end

  test "weather/language/:language redirects" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _credentials, _lambda_arn, _request, _opts ->
      {:ok, @lambda_response}
    end)

    response_conn =
      conn(:get, "/weather/language/en")
      |> Router.call([])

    assert {301, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(response_conn)
  end
end
