defmodule BelfrageWeb.Response.Headers.RouteSpecTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.RouteSpec
  alias Belfrage.Envelope

  @route_state_id {"NewsHomePage", "Webcore"}

  describe "when route spec (route_state_id) exists in envelope and production_environment is not live" do
    test "the routespec header is set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{private: %Envelope.Private{route_state_id: @route_state_id, production_environment: "test"}}
      output_conn = RouteSpec.add_header(input_conn, envelope)

      assert ["NewsHomePage.Webcore"] == get_resp_header(output_conn, "routespec")
    end
  end

  describe "when route spec (route_state_id) exists in envelope and production_environment is live" do
    test "the routespec header is not set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{private: %Envelope.Private{route_state_id: @route_state_id, production_environment: "live"}}
      output_conn = RouteSpec.add_header(input_conn, envelope)

      assert [] == get_resp_header(output_conn, "routespec")
    end
  end

  describe "when route spec (route_state_id) is nil" do
    test "the routespec header is not set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{private: %Envelope.Private{route_state_id: nil}}
      output_conn = RouteSpec.add_header(input_conn, envelope)

      assert [] == get_resp_header(output_conn, "routespec")
    end
  end
end
