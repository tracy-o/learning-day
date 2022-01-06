defmodule BelfrageWeb.Response.Headers.RouteSpecTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.RouteSpec
  alias Belfrage.Struct

  describe "when route spec (loop_id) exists in struct and production_environment is not live" do
    test "the routespec header is set" do
      input_conn = conn(:get, "/")
      struct = %Struct{private: %Struct.Private{loop_id: "NewsHomePage", production_environment: "test"}}
      output_conn = RouteSpec.add_header(input_conn, struct)

      assert ["NewsHomePage"] == get_resp_header(output_conn, "routespec")
    end
  end

  describe "when route spec (loop_id) exists in struct and production_environment is live" do
    test "the routespec header is not set" do
      input_conn = conn(:get, "/")
      struct = %Struct{private: %Struct.Private{loop_id: "NewsHomePage", production_environment: "live"}}
      output_conn = RouteSpec.add_header(input_conn, struct)

      assert [] == get_resp_header(output_conn, "routespec")
    end
  end

  describe "when route spec (loop_id) is nil" do
    test "the routespec header is not set" do
      input_conn = conn(:get, "/")
      struct = %Struct{private: %Struct.Private{loop_id: nil}}
      output_conn = RouteSpec.add_header(input_conn, struct)

      assert [] == get_resp_header(output_conn, "routespec")
    end
  end
end
