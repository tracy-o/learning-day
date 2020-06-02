defmodule BelfrageWeb.ResponseHeaders.ReqSvcChainTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.ReqSvcChain
  alias Belfrage.Struct

  test "when the response does not have 'req-svc-chain', BELFRAGE is set" do
    input_conn = conn(:get, "/")
    struct = %Struct{}

    output_conn = ReqSvcChain.add_header(input_conn, struct)

    assert ["BELFRAGE"] == get_resp_header(output_conn, "req-svc-chain")
  end

  test "when the response has 'req-svc-chain' then it is returned unmodified" do
    input_conn = conn(:get, "/")
    struct = %Struct{response: %Struct.Response{headers: %{"req-svc-chain" => "ORIGIN"}}}

    output_conn = ReqSvcChain.add_header(input_conn, struct)

    assert ["ORIGIN"] == get_resp_header(output_conn, "req-svc-chain")
  end
end
