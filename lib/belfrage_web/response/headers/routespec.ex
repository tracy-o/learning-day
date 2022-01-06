defmodule BelfrageWeb.Response.Headers.RouteSpec do
  import Plug.Conn
  alias Belfrage.Struct

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Struct{private: %Struct.Private{loop_id: loop_id, production_environment: env}})
      when env != "live" and is_binary(loop_id) do
    put_resp_header(conn, "routespec", loop_id)
  end

  @impl true
  def add_header(conn, _struct) do
    conn
  end
end
