defmodule BelfrageWeb.ResponseHeaders.AccessControlAllowOrigin do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders
  alias Belfrage.Struct

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{request: %Struct.Request{cdn?: true}}) do
    put_resp_header(conn, "access-control-allow-origin", "*")
  end

  @impl ResponseHeaders
  def add_header(conn, _struct), do: conn
end
