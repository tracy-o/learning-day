defmodule BelfrageWeb.Response.Headers.ReqSvcChain do
  import Plug.Conn

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn = %Plug.Conn{private: %{bbc_headers: bbc_headers}}, _envelope) do
    put_resp_header(
      conn,
      "req-svc-chain",
      Map.get(bbc_headers, :req_svc_chain, "BELFRAGE")
    )
  end
end
