defmodule EndToEnd.ResponseHeaders.CacheStatusTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_cache: 0, make_cached_response_stale: 1]

  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  alias Belfrage.Clients
  alias Belfrage.Clients.{LambdaMock, HTTPMock}

  @moduletag :end_to_end

  describe "cache scenarios" do
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

    test "cache response used as fallback" do
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
  end

  describe "ensure certain status codes don't cache and headers are respected from origin" do
    setup do
      clear_cache()
      start_supervised!({RouteState, "SomeClassicAppsRouteSpec"})
      :ok
    end

    test "202's" do
      stub_http_response(202)

      conn = make_request("https://news-app-classic.test.api.bbci.co.uk/202-ok-response")
      assert conn.status == 202
      assert cache_status_header(conn) == "MISS"

      conn = make_request("https://news-app-classic.test.api.bbci.co.uk/202-ok-response")
      assert conn.status == 202
      assert cache_status_header(conn) == "MISS"
      assert String.contains?(cache_control_heaeder(conn), "public")
    end
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

  defp stub_http_response(status) do
    stub(HTTPMock, :execute, fn _, _ -> http_response(status) end)
  end

  defp http_response(status) do
    {
      :ok,
      %Clients.HTTP.Response{
        status_code: status,
        headers: %{"cache-control" => "public, stale-if-error=90, stale-while-revalidate=30"},
        body: ""
      }
    }
  end

  defp make_request(path \\ "/200-ok-response") do
    conn(:get, path) |> Router.call([])
  end

  defp cache_status_header(conn) do
    get_resp_header(conn, "belfrage-cache-status") |> hd()
  end

  defp cache_control_heaeder(conn) do
    get_resp_header(conn, "cache-control") |> hd()
  end
end
