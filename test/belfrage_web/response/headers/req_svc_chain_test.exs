defmodule BelfrageWeb.Response.Headers.ReqSvcChainTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.ReqSvcChain

  @envelope %Belfrage.Envelope{}

  describe "when a service chain is already present in bbc_headers" do
    test "adds the chain to the response" do
      input_conn =
        conn(:get, "/")
        |> put_private(:bbc_headers, %{req_svc_chain: "GTM,BELFRAGE,ORIGIN"})

      output_conn = ReqSvcChain.add_header(input_conn, @envelope)

      assert ["GTM,BELFRAGE,ORIGIN"] == get_resp_header(output_conn, "req-svc-chain")
    end
  end

  describe "when a service chain is NOT present in bbc_headers" do
    test "it puts BELFRAGE as the response chain" do
      input_conn =
        conn(:get, "/")
        |> put_private(:bbc_headers, %{country: "gb"})

      output_conn = ReqSvcChain.add_header(input_conn, @envelope)

      assert ["BELFRAGE"] == get_resp_header(output_conn, "req-svc-chain")
    end
  end
end
