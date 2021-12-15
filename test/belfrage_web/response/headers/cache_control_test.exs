defmodule BelfrageWeb.Response.Headers.CacheControlTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.CacheControl
  alias Belfrage.Struct

  doctest CacheControl

  test "sets private cache control header." do
    input_conn = conn(:get, "/_web_core")

    output_conn =
      CacheControl.add_header(input_conn, %Struct{
        response: %Struct.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "private", max_age: 0, stale_while_revalidate: 0}
        }
      })

    assert ["private, stale-while-revalidate=0, max-age=0"] ==
             get_resp_header(output_conn, "cache-control")
  end

  test "sets public cache control header." do
    input_conn = conn(:get, "/_web_core")

    output_conn =
      CacheControl.add_header(input_conn, %Struct{
        response: %Struct.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30, stale_while_revalidate: 10}
        }
      })

    assert ["public, stale-while-revalidate=10, max-age=30"] ==
             get_resp_header(output_conn, "cache-control")
  end

  test "when max-age is nil" do
    input_conn = conn(:get, "/_web_core")

    output_conn =
      CacheControl.add_header(input_conn, %Struct{
        response: %Struct.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: nil, stale_while_revalidate: 10}
        }
      })

    assert ["public, stale-while-revalidate=10"] ==
             get_resp_header(output_conn, "cache-control")
  end
end
