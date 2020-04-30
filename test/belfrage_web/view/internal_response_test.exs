defmodule BelfrageWeb.View.InternalResponseTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.View.InternalResponse

  describe "content-type" do
    test "when accept is not set" do
      conn = conn(:get, "/")
      status = 404

      assert %Belfrage.Struct.Response{
               body: "content for file test/support/resources/not-found.html<!-- Belfrage -->",
               cache_directive: %{
                 cacheability: "public",
                 max_age: 30,
                 stale_if_error: 0,
                 stale_while_revalidate: 0
               },
               fallback: false,
               headers: %{"content-type" => "text/html; charset=utf-8", "b-early" => "1"},
               http_status: status
             } == InternalResponse.new(conn, status)
    end

    test "when accept not set, and status code does not have a BBC error page" do
      conn = conn(:get, "/")
      status = 418

      assert %Belfrage.Struct.Response{
               body: "<h1>#{status}</h1>\n<!-- Belfrage -->",
               cache_directive: %{
                 cacheability: "private",
                 max_age: 0,
                 stale_if_error: 0,
                 stale_while_revalidate: 0
               },
               fallback: false,
               headers: %{"content-type" => "text/html; charset=utf-8", "b-early" => "1"},
               http_status: status
             } == InternalResponse.new(conn, status)
    end

    test "when accept is application/json" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("accept", "application/json")
      status = 404

      assert %Belfrage.Struct.Response{
               body: "{\"status\":#{status}}",
               cache_directive: %{
                 cacheability: "public",
                 max_age: 30,
                 stale_if_error: 0,
                 stale_while_revalidate: 0
               },
               fallback: false,
               headers: %{"content-type" => "application/json", "b-early" => "1"},
               http_status: status
             } == InternalResponse.new(conn, status)
    end

    test "when accept is text/plain" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("accept", "text/plain")
      status = 404

      assert %Belfrage.Struct.Response{
               body: "#{status}, Belfrage",
               cache_directive: %{
                 cacheability: "public",
                 max_age: 30,
                 stale_if_error: 0,
                 stale_while_revalidate: 0
               },
               fallback: false,
               headers: %{"content-type" => "text/plain", "b-early" => "1"},
               http_status: status
             } == InternalResponse.new(conn, status)
    end
  end
end
