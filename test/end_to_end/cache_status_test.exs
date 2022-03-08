defmodule EndToEnd.ResponseHeaders.CacheStatusTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_cache: 0, make_cached_response_stale: 1]

  alias BelfrageWeb.Router
  alias Belfrage.{Clients.LambdaMock, RouteState}

  @moduletag :end_to_end

  setup do
    clear_cache()
    start_supervised!({RouteState, "SomeRouteState"})
    :ok
  end

  test "cache miss" do
    stub_lambda()

    conn = make_request()
    assert conn.status == 200
    assert cache_status_header(conn) == "MISS"
  end

  test "cache hit" do
    stub_lambda()

    conn = make_request()
    assert conn.status == 200
    assert cache_status_header(conn) == "MISS"

    conn = make_request()
    assert conn.status == 200
    assert cache_status_header(conn) == "HIT"
  end

  test "cached response used as fallback" do
    stub_lambda()

    conn = make_request()
    assert conn.status == 200
    assert cache_status_header(conn) == "MISS"

    make_cached_response_stale(conn)
    stub_lambda_error()

    conn = make_request()
    assert conn.status == 200
    assert cache_status_header(conn) == "STALE"
  end

  defp stub_lambda() do
    stub_lambda(
      {:ok,
       %{
         "headers" => %{
           "cache-control" => "public, max-age=30"
         },
         "statusCode" => 200,
         "body" => "OK"
       }}
    )
  end

  defp stub_lambda_error() do
    stub_lambda({:error, :invoke_failure})
  end

  defp stub_lambda(response) do
    stub(LambdaMock, :call, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
      response
    end)
  end

  defp make_request() do
    conn(:get, "/200-ok-response") |> Router.call([])
  end

  defp cache_status_header(conn) do
    get_resp_header(conn, "belfrage-cache-status") |> hd()
  end
end
