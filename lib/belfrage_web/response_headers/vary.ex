defmodule BelfrageWeb.ResponseHeaders.Vary do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, _struct) do
    put_resp_header(conn, "vary", "Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country")
  end
end
