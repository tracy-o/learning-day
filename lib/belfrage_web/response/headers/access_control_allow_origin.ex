defmodule BelfrageWeb.Response.Headers.AccessControlAllowOrigin do
  import Plug.Conn

  alias Belfrage.Struct

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Struct{request: %Struct.Request{cdn?: true}}) do
    put_resp_header(conn, "access-control-allow-origin", "*")
  end

  @impl true
  def add_header(conn, _struct), do: conn
end
