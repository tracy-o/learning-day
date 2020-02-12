defmodule BelfrageWeb.ResponseHeaders.SignatureTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Signature
  alias Belfrage.Struct

  describe "when request_hash exists in struct" do
    test "the signature header is set" do
      input_conn = conn(:get, "/")
      struct = %Struct{request: %Struct.Request{request_hash: "a-request-hash"}}
      output_conn = Signature.add_header(input_conn, struct)

      assert ["a-request-hash"] == get_resp_header(output_conn, "bsig")
    end
  end

  describe "when request_hash does not exist in struct" do
    test "the signature header is not set" do
      input_conn = conn(:get, "/")
      struct = %Struct{}
      output_conn = Signature.add_header(input_conn, struct)

      assert [] == get_resp_header(output_conn, "bsig")
    end
  end
end
