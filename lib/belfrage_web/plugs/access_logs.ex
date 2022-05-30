defmodule BelfrageWeb.Plugs.AccessLogs do
  require Logger
  import Plug.Conn, only: [register_before_send: 2]
  alias Belfrage.Logger.HeaderRedactor

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send(conn, &write_access_log/1)
  end

  defp write_access_log(conn) do
    Logger.log(:info, "", %{
      path: conn.request_path,
      status: conn.status,
      method: conn.method,
      req_headers: HeaderRedactor.redact(conn.req_headers),
      resp_headers: HeaderRedactor.redact(conn.resp_headers),
      query_string: conn.query_string
    })

    conn
  end
end
