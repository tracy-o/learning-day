defmodule BelfrageWeb.Response.Headers.Server do
  import Plug.Conn

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, _envelope) do
    put_resp_header(conn, "server", "Belfrage")
  end
end
