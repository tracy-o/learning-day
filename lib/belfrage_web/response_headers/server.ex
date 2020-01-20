defmodule BelfrageWeb.ResponseHeaders.Server do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, _struct) do
    put_resp_header(conn, "server", "Belfrage")
  end
end
