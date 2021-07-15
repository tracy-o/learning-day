defmodule BelfrageWeb.View.InternalResponseTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.View.InternalResponse
  alias Belfrage.Struct

  describe "content-type" do
    test "when accept is not set" do
      conn = conn(:get, "/")
      status = 404

      assert %Struct.Response{
               body: "content for file test/support/resources/not-found.html<!-- Belfrage -->",
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "public",
                 max_age: 30,
                 stale_if_error: 90,
                 stale_while_revalidate: 60
               },
               fallback: false,
               headers: %{"content-type" => "text/html; charset=utf-8"},
               http_status: status
             } == InternalResponse.new(conn, status, false)
    end

    test "when accept not set, and status code does not have a BBC error page" do
      conn = conn(:get, "/")
      status = 418

      assert %Struct.Response{
               body: "<h1>#{status}</h1>\n<!-- Belfrage -->",
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "public",
                 max_age: 5,
                 stale_while_revalidate: 15
               },
               fallback: false,
               headers: %{"content-type" => "text/html; charset=utf-8"},
               http_status: status
             } == InternalResponse.new(conn, status, false)
    end

    test "when accept is application/json" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("accept", "application/json")
      status = 404

      assert %Struct.Response{
               body: "{\"status\":#{status}}",
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "public",
                 max_age: 30,
                 stale_if_error: 90,
                 stale_while_revalidate: 60
               },
               fallback: false,
               headers: %{"content-type" => "application/json"},
               http_status: status
             } == InternalResponse.new(conn, status, false)
    end

    test "when accept is text/plain" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("accept", "text/plain")
      status = 404

      assert %Struct.Response{
               body: "#{status}, Belfrage",
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "public",
                 max_age: 30,
                 stale_if_error: 90,
                 stale_while_revalidate: 60
               },
               fallback: false,
               headers: %{"content-type" => "text/plain"},
               http_status: status
             } == InternalResponse.new(conn, status, false)
    end
  end

  describe "cache-control" do
    test "404 cacheability" do
      conn = conn(:get, "/")
      status = 404

      assert %Struct.Response{
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "public",
                 max_age: 30,
                 stale_if_error: 90,
                 stale_while_revalidate: 60
               }
             } = InternalResponse.new(conn, status, false)
    end

    test "server error cacheability" do
      conn = conn(:get, "/")
      status = 500

      assert %Struct.Response{
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "public",
                 max_age: 5,
                 stale_while_revalidate: 15
               }
             } = InternalResponse.new(conn, status, false)
    end

    test "redirect cacheability" do
      conn = conn(:get, "/")
      status = 301

      assert %Struct.Response{
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "public",
                 max_age: 60,
                 stale_while_revalidate: 60
               }
             } = InternalResponse.new(conn, status, false)
    end

    test "cache-control is private for 500s with personalised: true and signed in" do
      conn = conn(:get, "/")
      status = 500

      assert %Struct.Response{
               cache_directive: %Belfrage.CacheControl{
                 cacheability: "private",
                 max_age: 5,
                 stale_while_revalidate: 15
               }
             } = InternalResponse.new(conn, status, true)
    end
  end
end
