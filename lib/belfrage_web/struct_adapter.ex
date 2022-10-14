defmodule BelfrageWeb.StructAdapter do
  alias BelfrageWeb.StructAdapter
  alias Plug.Conn

  def adapt(conn = %Conn{}, route_state_id) do
    Logger.metadata(route_state_id: route_state_id)

    conn
    |> StructAdapter.Request.adapt()
    |> StructAdapter.Private.adapt(conn.private, route_state_id)
  end
end
