defmodule BelfrageWeb.Response.Headers.ReqSvcChainTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.ReqSvcChain
  alias Belfrage.Envelope

  test "when the response has 'req-svc-chain' then it is returned" do
    input_conn = conn(:get, "/")
    envelope = %Envelope{response: %Envelope.Response{headers: %{"req-svc-chain" => "BELFRAGE,ORIGIN"}}}

    output_conn = ReqSvcChain.add_header(input_conn, envelope)

    assert ["BELFRAGE,ORIGIN"] == get_resp_header(output_conn, "req-svc-chain")
  end

  test "when the response does not have 'req-svc-chain' the request envelope value is returned" do
    input_conn = conn(:get, "/")
    envelope = %Envelope{request: %Envelope.Request{req_svc_chain: "GTM,BELFRAGE"}}

    output_conn = ReqSvcChain.add_header(input_conn, envelope)

    assert ["GTM,BELFRAGE"] == get_resp_header(output_conn, "req-svc-chain")
  end

  test "when the response and request don't have 'req-svc-chain' set, BELFRAGE is returned" do
    input_conn = conn(:get, "/")
    envelope = %Envelope{}

    output_conn = ReqSvcChain.add_header(input_conn, envelope)

    assert ["BELFRAGE"] == get_resp_header(output_conn, "req-svc-chain")
  end
end
