defmodule BelfrageWeb.Plugs.RequestId do
  @moduledoc """
  Sets the request ID in the process information.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    request_id = UUID.uuid4(:hex)
    Logger.metadata(request_id: request_id)

    Plug.Conn.put_private(conn, :request_id, request_id)
  end
end
