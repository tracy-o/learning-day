defmodule BelfrageWeb.Response.Headers.RequestIdTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.RequestId
  alias Belfrage.Envelope

  describe "when request_id exists in envelope" do
    test "the request id header is set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{request: %Envelope.Request{request_id: "a-request-id"}}
      output_conn = RequestId.add_header(input_conn, envelope)

      assert ["a-request-id"] == get_resp_header(output_conn, "brequestid")
    end
  end

  describe "when request_id does not exist in envelope" do
    test "the request id header is explicitly nil" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{request: %Envelope.Request{request_id: nil}}
      output_conn = RequestId.add_header(input_conn, envelope)

      assert [] == get_resp_header(output_conn, "brequestid")
    end

    test "the request id header is not set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{}
      output_conn = RequestId.add_header(input_conn, envelope)

      assert [] == get_resp_header(output_conn, "brequestid")
    end
  end
end
