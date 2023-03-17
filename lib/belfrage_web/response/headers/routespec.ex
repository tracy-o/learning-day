defmodule BelfrageWeb.Response.Headers.RouteSpec do
  import Plug.Conn
  alias Belfrage.{Envelope, RouteState}

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Envelope{
        private: %Envelope.Private{route_state_id: route_state_id, production_environment: env}
      })
      when env != "live" and is_tuple(route_state_id) do
    put_resp_header(conn, "routespec", RouteState.format_id(route_state_id))
  end

  @impl true
  def add_header(conn, _envelope) do
    conn
  end
end
