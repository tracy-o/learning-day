defmodule BelfrageWeb.Response.Headers.SignatureTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.Signature
  alias Belfrage.Envelope

  describe "when request_hash exists in envelope" do
    test "the signature header is set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{request: %Envelope.Request{request_hash: "a-request-hash"}}
      output_conn = Signature.add_header(input_conn, envelope)

      assert ["a-request-hash"] == get_resp_header(output_conn, "bsig")
    end
  end

  describe "when request_hash does not exist in envelope" do
    test "the signature header is not set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{}
      output_conn = Signature.add_header(input_conn, envelope)

      assert [] == get_resp_header(output_conn, "bsig")
    end
  end
end
