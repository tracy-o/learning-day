defmodule EndToEnd.HttpRedirectTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  import Belfrage.Test.CachingHelper, only: [clear_cache: 0]

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  test "http redirects" do
    response_conn =
      conn(:get, "http://www.example.com/foo-bar?query=query_string")
      |> put_req_header("x-bbc-edge-scheme", "http")
      |> Router.call([])

    assert {302,
            [
              {"cache-control", "public, stale-while-revalidate=10, max-age=60"},
              {"location", "https://www.example.com/foo-bar?query=query_string"},
              {"via", "1.1 Belfrage"},
              {"server", "Belfrage"},
              {"x-bbc-no-scheme-rewrite", "1"},
              {"req-svc-chain", "BELFRAGE"},
              {"vary", "x-bbc-edge-scheme"}
            ], ""} = sent_resp(response_conn)
  end

  setup do
    start_supervised!({RouteState, "SomeRouteState"})
    clear_cache()
    :ok
  end

  test "no redirect when http in uri but https in edge-scheme" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _credentials, _lambda_arn, _request, _opts ->
      {:ok, @lambda_response}
    end)

    response_conn =
      conn(:get, "http://www.example.com/")
      |> put_req_header("x-bbc-edge-scheme", "https")
      |> Router.call([])

    assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(response_conn)
  end

  test "no redirect when scheme is https" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _credentials, _lambda_arn, _request, _opts ->
      {:ok, @lambda_response}
    end)

    response_conn =
      conn(:get, "https://www.example.com/")
      |> put_req_header("x-bbc-edge-scheme", "https")
      |> Router.call([])

    assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(response_conn)
  end

  test "redirect when uri scheme is https and edge scheme is http" do
    response_conn =
      conn(:get, "https://www.example.com/foo-bar?query=query_string")
      |> put_req_header("x-bbc-edge-scheme", "http")
      |> Router.call([])

    assert {302,
            [
              {"cache-control", "public, stale-while-revalidate=10, max-age=60"},
              {"location", "https://www.example.com/foo-bar?query=query_string"},
              {"via", "1.1 Belfrage"},
              {"server", "Belfrage"},
              {"x-bbc-no-scheme-rewrite", "1"},
              {"req-svc-chain", "BELFRAGE"},
              {"vary", "x-bbc-edge-scheme"}
            ], ""} = sent_resp(response_conn)
  end
end
