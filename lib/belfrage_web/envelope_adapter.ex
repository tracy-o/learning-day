defmodule BelfrageWeb.EnvelopeAdapter do
  alias BelfrageWeb.EnvelopeAdapter
  alias Plug.Conn

  def adapt(conn = %Conn{}, route_state_id) do
    Logger.metadata(route_state_id: route_state_id)

    conn
    |> EnvelopeAdapter.Request.adapt()
    |> EnvelopeAdapter.Private.adapt(conn.private, route_state_id)
  end
end
