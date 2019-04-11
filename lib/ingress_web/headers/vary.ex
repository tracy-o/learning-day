defmodule IngressWeb.Headers.Vary do
  import Plug.Conn

  alias IngressWeb.Behaviours.Headers

  @behaviour Headers

  @impl Headers

  def add_header(conn, _struct) do
    put_resp_header(conn, "vary", "Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country")
  end
end
