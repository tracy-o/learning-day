defmodule BelfrageWeb.ResponseHeaders.CacheControlTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.CacheControl
  alias Belfrage.Struct
  alias Test.Support.StructHelper

  doctest CacheControl

  test "Adding cache control returns conn with cache control header with max age equal to the cache directive in the struct." do
    input_conn = conn(:get, "/_web_core")

    output_conn =
      CacheControl.add_header(input_conn, %Struct{
        response: StructHelper.response_struct(headers: %{"cache-control" => "private, max-age=0"})
      })

    assert ["private, max-age=0"] ==
             get_resp_header(output_conn, "cache-control")
  end
end
