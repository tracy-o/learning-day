defmodule BelfrageWeb.ResponseHeaders.RouteSpecTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.RouteSpec
  alias Belfrage.Struct

  describe "when route spec (loop_id) exists in struct" do
    test "the belfrage-routespec header is set" do
      input_conn = conn(:get, "/")
      struct = %Struct{request: %Struct.Private{loop_id: "NewsHomePage"}}
      output_conn = RouteSpec.add_header(input_conn, struct)

      assert ["NewsHomePage"] == get_resp_header(output_conn, "belfrage-routespec")
    end
  end

  describe "when route spec (loop_id) is nil" do
    test "the belfrage-routespec header is not set" do
      input_conn = conn(:get, "/")
      struct = %Struct{request: %Struct.Private{loop_id: nil}}
      output_conn = RouteSpec.add_header(input_conn, struct)

      assert [] == get_resp_header(output_conn, "belfrage-routespec")
    end
  end
end
