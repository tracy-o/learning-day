defmodule BelfrageWeb.ResponseHeaders.ReqSvcChain do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct) do
    put_resp_header(
      conn,
      "req-svc-chain",
      header(Map.get(struct.response.headers, "req-svc-chain"), struct.request.req_svc_chain)
    )
  end

  defp header(_existing = nil, _req_svc_chain = nil), do: "BELFRAGE"

  defp header(_existing = nil, req_svc_chain), do: req_svc_chain

  defp header(existing, _), do: existing
end
