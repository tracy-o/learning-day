defmodule IngressWeb.Headers.CacheControlTest do
  use ExUnit.Case
  use Plug.Test

  alias IngressWeb.Headers.CacheControl
  alias Ingress.Struct
  alias Test.Support.StructHelper

  doctest CacheControl

  test "Adding cache control returns conn with cache control header with max age of 30 added" do
    input_conn = conn(:get, "/_web_core")

    output_conn =
      CacheControl.add_header(input_conn, %Struct{response: StructHelper.response_struct()})

    assert ["public, stale-while-revalidate=10, max-age=30"] ==
             get_resp_header(output_conn, "cache-control")
  end

  test "Adding cache control with a 404 response returns conn with cache control header with max age of 5 added" do
    input_conn = conn(:get, "/_web_core")

    output_conn =
      CacheControl.add_header(input_conn, %Struct{
        response: StructHelper.response_struct(%{http_status: 404})
      })

    assert ["public, stale-while-revalidate=10, max-age=5"] ==
             get_resp_header(output_conn, "cache-control")
  end
end
