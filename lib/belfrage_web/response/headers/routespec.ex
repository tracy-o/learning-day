defmodule BelfrageWeb.Response.Headers.RouteSpec do
  import Plug.Conn
  alias Belfrage.Struct

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Struct{private: %Struct.Private{route_state_id: route_state_id, production_environment: env}})
      when env != "live" and is_binary(route_state_id) do
    put_resp_header(conn, "routespec", route_state_id)
  end

  @impl true
  def add_header(conn, _struct) do
    conn
  end
end
