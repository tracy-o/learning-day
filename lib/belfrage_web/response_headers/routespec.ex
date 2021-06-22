defmodule BelfrageWeb.ResponseHeaders.RouteSpec do
  import Plug.Conn
  alias Belfrage.Struct
  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{private: %Struct.Private{loop_id: loop_id, production_environment: env}})
      when env != "live" and is_binary(loop_id) do
    put_resp_header(conn, "routespec", loop_id)
  end

  @impl ResponseHeaders
  def add_header(conn, struct) do
    conn
  end
end