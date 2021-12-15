defmodule BelfrageWeb.Response.Headers.AccessControlAllowOriginTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.AccessControlAllowOrigin
  alias Belfrage.Struct

  test "when in cdn mode, allow-control-allow-origin is set" do
    input_conn = conn(:get, "/")

    output_conn =
      AccessControlAllowOrigin.add_header(input_conn, %Struct{
        request: %Struct.Request{
          cdn?: true
        }
      })

    assert ["*"] == get_resp_header(output_conn, "access-control-allow-origin")
  end

  test "when not in cdn mode, allow-control-allow-origin is not set" do
    input_conn = conn(:get, "/")

    output_conn =
      AccessControlAllowOrigin.add_header(input_conn, %Struct{
        request: %Struct.Request{
          cdn?: false
        }
      })

    assert [] == get_resp_header(output_conn, "access-control-allow-origin")
  end
end
