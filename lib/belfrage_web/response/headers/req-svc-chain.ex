defmodule BelfrageWeb.Response.Headers.ReqSvcChain do
  import Plug.Conn

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, envelope) do
    put_resp_header(
      conn,
      "req-svc-chain",
      header(Map.get(envelope.response.headers, "req-svc-chain"), envelope.request.req_svc_chain)
    )
  end

  defp header(_existing = nil, _req_svc_chain = nil), do: "BELFRAGE"

  defp header(_existing = nil, req_svc_chain), do: req_svc_chain

  defp header(existing, _), do: existing
end
