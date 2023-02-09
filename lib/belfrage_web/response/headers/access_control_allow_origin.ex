defmodule BelfrageWeb.Response.Headers.AccessControlAllowOrigin do
  import Plug.Conn

  alias Belfrage.Envelope

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Envelope{request: %Envelope.Request{cdn?: true}}) do
    put_resp_header(conn, "access-control-allow-origin", "*")
  end

  @impl true
  def add_header(conn, _envelope), do: conn
end
