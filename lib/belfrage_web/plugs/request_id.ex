defmodule BelfrageWeb.Plugs.RequestId do
  @moduledoc """
  Sets the request ID in the process information.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.put_private(conn, :request_id, UUID.uuid4(:hex))
  end
end
