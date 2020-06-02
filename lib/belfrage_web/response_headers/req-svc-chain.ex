defmodule BelfrageWeb.ResponseHeaders.ReqSvcChain do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct) do
    put_resp_header(conn, "req-svc-chain", header(Map.get(struct.response.headers, "req-svc-chain")))
  end

  defp header(_existing = nil), do: "BELFRAGE"

  defp header(existing), do: existing
end
